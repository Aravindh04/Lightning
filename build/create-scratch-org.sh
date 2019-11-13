# Get the private key from the environment variable
echo "Setting up DevHub Connection..."
mkdir keys
echo $SFDC_SERVER_KEY | base64 -d > keys/server.key

# Authenticate to salesforce
echo "Authenticating..."
sfdx force:auth:jwt:grant --clientid $SFDC_PROD_CLIENTID --jwtkeyfile keys/server.key --username $SFDC_PROD_USER --setdefaultdevhubusername -a DevHub

#Create a scratch org
echo "Creating the Scratch Org..."
sfdx force:org:create -f config/project-scratch-def.json -a ${CIRCLE_BRANCH} -s



job-definition: &jobdef
    docker:
        - image: circleci/node:latest
    steps:
        - checkout
        - restore_cache:
            keys:
                - sfdx-6.8.2-local
        - run:
            name: Install Salesforce DX
            command: |
                if [ ! -d node_modules/sfdx-cli ]; then
                    export SFDX_AUTOUPDATE_DISABLE=true
                    export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
                    export SFDX_DOMAIN_RETRY=300
                    npm install sfdx-cli@6.8.2
                    node_modules/sfdx-cli/bin/run --version
                    node_modules/sfdx-cli/bin/run plugins --core
                fi
        - save_cache:
            key: sfdx-6.8.2-local
            paths: 
                - node_modules
        - run: 
            name: Create Scratch Org
            command: |
                openssl aes-256-cbc -k $SFDC_SERVER_KEY -in assets/server.key.enc -out assets/server.key -d
                node_modules/sfdx-cli/bin/run force:auth:jwt:grant --clientid $SFDC_PROD_CLIENTID --jwtkeyfile assets/server.key --username $SFDC_PROD_USER --setdefaultdevhubusername -a DevHub
                echo "Creating scratch org with definition $SCRATCH_DEF"
                node_modules/sfdx-cli/bin/run force:org:create -v DevHub -s -f "config/$SCRATCH_DEF" -a scratch
        - run:
            name: Remove Server Key
            when: always
            command: |
                rm assets/server.key
        - run: 
            name: Push Source
            command: |
                node_modules/sfdx-cli/bin/run force:source:push -u scratch
        - run:
            name: Run Apex Tests
            command: |
                mkdir ~/tests
                mkdir ~/tests/apex
                node_modules/sfdx-cli/bin/run force:apex:test:run -u scratch -c -r human -d ~/tests/apex -w 9999
        - run: 
            name: Push to Codecov.io (Optional Step)
            command: |
                cp ~/tests/apex/test-result-codecoverage.json .
                bash <(curl -s https://codecov.io/bash)
        - run: 
            name: Clean Up
            when: always
            command: |
                node_modules/sfdx-cli/bin/run force:org:delete -u scratch -p
                rm ~/tests/apex/*.txt ~/tests/apex/test-result-7*.json
        - store_artifacts:
            path: ~/tests
        - store_test_results:
            path: ~/tests

version: 2
jobs:
  static-analysis:
    docker:
      - image: circleci/openjdk:latest
    steps:
      - checkout
      - restore_cache:
          keys: 
            - pmd-v6.19.0
      - run:
          name: Install PMD
          command: |
              if [ ! -d pmd-bin-6.19.0 ]; then
                  curl -L "https://github.com/pmd/pmd/releases/download/pmd_releases/6.19.0/pmd-bin-6.19.0.zip" -o pmd-bin-6.19.0.zip
                  unzip pmd-bin-6.19.0.zip
                  rm pmd-bin-6.19.0.zip
              fi
      - save_cache:
          key: pmd-v6.19.0
          paths: 
              - pmd-bin-6.19.0
      - run: 
          name: Run Static Analysis
          command: |
              pmd-bin-6.19.0/bin/run.sh pmd -d . -R $RULESET -f text -l apex -r static-analysis.txt 
      - store_artifacts:
          path: static-analysis.txt
  build-enterprise:
     <<: *jobdef
     environment:
        SCRATCH_DEF: project-scratch-def.json
  build-developer: 
     <<: *jobdefÍ
     environment:
        SCRATCH_DEF: developer.json
workflows:
  version: 2
  test_and_static:
    jobs:
      - build-enterprise
      - build-developer
      - static-analysis