# Global Condition - Virtual Machine

$Parameters = @{
    Name = "Virtual Machine"
    Description = "Returns true if the Device's Model contains the word Virtual."
    DataType = "Boolean"
    Namespace = "root\cimv2"
    Class = "Win32_ComputerSystem"
    Property = "Model"
    WhereClause = "Model LIKE '%Virtual%'"
}

New-CMGlobalConditionWqlQuery @Parameters
