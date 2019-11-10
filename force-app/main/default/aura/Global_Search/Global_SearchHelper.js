({
	fetchValues : function(component, event, helper, cusMap, callback) {
        var constants = [];
        constants.push('-- Select --');
        for(var singlekey in cusMap){
            constants.push(singlekey);
        }
        callback.call(this,constants);
	},
    
    mapToList : function(component, event, helper, cusMap, callback) {
        var items = [];
        var fstItem = {
            'value':'--Select--',
            'label':'--Select--'
        };
        items.push(fstItem);
        for(var keyName in cusMap){
            var item = {
                value: keyName,
                label: cusMap[keyName]
            };
            items.push(item);
        }
        callback.call(this,items);
    },
    
    tableCreation : function(component, event, helper, elmtId, tdTit, tdData) {
        try{
            var table = document.getElementById(elmtId);
            //
            console.log('tableId : '+elmtId+'| table :'+JSON.stringify(table)+'\n '+table);
            if(table.rows.length < 2){
                for(var i=0; i<tdData.length; i++){
                    var tableRow = document.createElement('tr');
                    var tableData1 = document.createElement('td');
                    var tableData2 = document.createElement('td');
                    var tableDataNode1 = document.createTextNode(tdTit[i]);
                    var tableDataNode2 = document.createTextNode(tdData[i]);
                    tableData1.appendChild(tableDataNode1);
                    tableData2.appendChild(tableDataNode2);
                    tableRow.appendChild(tableData1);
                    tableRow.appendChild(tableData2);
                    document.getElementById(elmtId).appendChild(tableRow);
                }
            }else{
                console.log('Table created already');
            }
            
        }catch(e){
            console.log('Exception Occured : '+e.description);
        }
    },
    
    fieldSelections : function(component, event, helper, tableName) {
        var Mfields = component.get('v.fldDescription');
        var table = document.getElementById(tableName);
        var tabKey = event.getParam('name');
        
        
        var fldTitle = ['Name', 'Label', 'Field type', 'Data type', 'Default value', 'Is Lookup', 'Non - mandatory', 'Updatable', 'Relationship Name', 'Parent sObject', 'Writable', 'Cutom field', 'Unique value', 'Delete Restricted'];
        //Array of Map values
        var fldSeps = Mfields[tabKey];
        //console.log('tableId : '+elmtId+'| table :'+JSON.stringify(table)+'\n '+table);
        tableName = '#'+tableName;
        
        $(tableName).empty();
        var headerRow = document.createElement('tr');
        var headerData1 = document.createElement('th');
        var headerData2 = document.createElement('th');
        var headerDataNode1 = document.createTextNode('FIELD');
        var headerDataNode2 = document.createTextNode('VALUE');
        headerData1.appendChild(headerDataNode1);
        headerData2.appendChild(headerDataNode2);
        headerRow.appendChild(headerData1);
        headerRow.appendChild(headerData2);
        table.appendChild(headerRow);
        for(var i=0; i<fldSeps.length; i++){
            var tableRow = document.createElement('tr');
            var tableData1 = document.createElement('td');
            var tableData2 = document.createElement('td');
            var tableDataNode1 = document.createTextNode(fldTitle[i]);
            var tableDataNode2 = document.createTextNode(fldSeps[i]);
            console.log(fldSeps[i]);
            tableData1.appendChild(tableDataNode1);
            tableData2.appendChild(tableDataNode2);
            tableRow.appendChild(tableData1);
            tableRow.appendChild(tableData2);
            table.appendChild(tableRow);
        }
    }
})