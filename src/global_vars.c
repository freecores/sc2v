#include "sc2v_step1.h"

/* Global var to store Regs */
  RegNode *regslist;
/* Global var to store Defines */
  DefineNode *defineslist;
/*Global var to store Structs */
  StructNode *structslist;
  StructRegNode *structsreglist;

#include "sc2v_step2.h"

/*Global var to read from file_writes.sc2v*/
  WriteNode *writeslist;
/*Global var to store ports*/
  PortNode *portlist;
/* Global var to store signals*/
  SignalNode *signalslist;
/* Global var to store sensitivity list*/
  SensibilityNode *sensibilitylist;
/* Global var to store process list*/
  ProcessNode *processlist;
/* Global var to store instantiated modules*/
  InstanceNode *instanceslist;
/*List of enumerates*/
  EnumeratesNode *enumerateslist;
  EnumListNode *enumlistlist;
/* Global var to store functions inputs list*/
  FunctionInputNode *funcinputslist;
/* Global var to store process list*/
  FunctionNode *functionslist;