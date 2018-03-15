/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    
    address owner;
    Employee[] employees;
    uint constant payDuration = 10 seconds;
    
    //初始化
    function Payroll(){
        
         owner= msg.sender;
    }
    //
    struct Employee {
        
        address id;
        uint salary;
        uint lastPayDay;
    }
    
    function _getEmployee(address empId)private returns (Employee,uint){
        
        for(uint i = 0; i<employees.length; i++){
             
            if(employees[i].id == empId){
                
                return(employees[i],i);       
            }   
        }        
    }
    
    function _partialPay(Employee emp,uint salary) private{
        
          uint sum =  emp.salary * (now - emp.lastPayDay) / payDuration ;
          emp.id.transfer(sum);
        
    }
    
    function addEmployee(address empId,uint s){
        require(msg.sender == owner);
        var(employee,index) = _getEmployee(empId);
        
        //tips :check
        assert(employee.id == 0x0);
        employees.push(Employee(empId,s * 1 ether,now));
        
    }
    
    function removeEmployee(address empId) public{
        require(msg.sender == owner);
        var(employee,index)  = _getEmployee(empId);

        //tips :check
        assert(employee.id != 0x0);
        _partialPay(employee,employee.salary);
        
        //delete
        delete(employees[index]);
        employees[index] =employees[employees.length -1];
        employees.length-=1;
        
    }
  
    function updateEmplpyee (address empId,uint n){
        
        require(msg.sender == owner);
        
        var(employee,index) =  _getEmployee(empId);
        
        assert(employee.id!= 0x0);
         _partialPay(employee,employee.salary);
         
         //warning!!!!!!!!!!!!!!!!! storage     
        employees[index].lastPayDay = now;
        employees[index].salary = n * 1 ether;
    }

   function addFund() payable returns (uint){
        return  this.balance;
    }

   function calculateRunway() public  returns (uint){
       uint sumBalance = 0;
        for(uint i = 0; i<employees.length; i++){
           
           sumBalance += employees[i].salary;
       }
        return this.balance / sumBalance;
    }


   function hasEnoughFound()public returns(bool){
        return calculateRunway() > 0;
    }
   function getPaid()public {

        var(employee,index) = _getEmployee(msg.sender);
        
        assert(employee.id != 0x0);
        uint nextDay = employee.lastPayDay + payDuration;

        assert(nextDay < now);
        employee.lastPayDay = nextDay;
        employee.id.transfer(employee.salary);

    }
}
