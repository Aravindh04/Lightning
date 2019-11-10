public class DoingFizzBuzz {
    
    public static String FizzBuzz(integer x){
        String returnVal = '';
        //system.debug('x : '+x+'\t'+Math.mod(x, 3));
        if(Math.mod(x,3) == 0){
            returnVal += 'fizz';
            //returnVal = returnVal + 'fizz';
        }
        if(Math.mod(x, 5) == 0){
            returnVal += 'buzz';
            //returnVal = returnVal + 'buzz';
        }
        if(Math.mod(x, 3) != 0 && Math.mod(x, 5) != 0){
            returnVal = String.valueOf(x);
        }
        return returnVal;
    }

}