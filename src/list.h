/* -----------------------------------------------------------------------------
 *
 *  SystemC to Verilog Translator v0.1
 *  Provided by OpenSoc Design
 *  
 *  www.opensocdesign.com
 *
 * -----------------------------------------------------------------------------
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Library General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */


typedef struct _define_node {
	char *name;
	struct _define_node *next;
} DefineNode;

typedef struct _defines_list {
	DefineNode *first;
	DefineNode *last;
} DefinesList;

typedef struct _write_node {
	char *name;
	struct _write_node *next;
} WriteNode;

typedef struct _writes_list {
	WriteNode *first;
	WriteNode *last;
} WritesList;

typedef struct _reg_node {
	char *name;
	char *name2;
	struct _reg_node *next;
} RegNode;

typedef struct _regs_list {
	RegNode *first;
	RegNode *last;
} RegsList;

typedef struct _port_node {
	char *name;
	char *tipo;
	int size;
	struct _port_node *next;
} PortNode;

typedef struct _port_list {
	PortNode *first;
	PortNode *last;
} PortList;

typedef struct _signal_node {
	char *name;
	int size;
	struct _signal_node *next;
} SignalNode;

typedef struct _signals_list {
	SignalNode *first;
	SignalNode *last;
} SignalsList;

typedef struct _bind_node {
	char *nameport;
	char *namebind;
	struct _bind_node *next;
} BindNode;

typedef struct _binds_list {
	BindNode *first;
	BindNode *last;
} BindsList;
	
typedef struct _instance_node {
	char *nameinstance;
	char *namemodulo;
	BindsList *bindslist;
	struct _instance_node *next;
	} InstanceNode;

typedef struct _instances_list {
	InstanceNode *first;
	InstanceNode *last;
} InstancesList;
	
typedef struct _sensibility_node {
	char *tipo;
	char *name;
	struct _sensibility_node *next;
} SensibilityNode;

typedef struct _sensibility_list {
	SensibilityNode *first;
	SensibilityNode *last;
} SensibilityList;

typedef struct _process_node {
	char *name;
	char *tipo;	//comb or seq
	SensibilityList *list;
	struct _process_node *next;
} ProcessNode;

typedef struct _process_list {
	ProcessNode *first;
	ProcessNode *last;
} ProcessList;

typedef struct _enumerates_node {
	char *name;
	struct _enumerates_node *next;
} EnumeratesNode;

typedef struct _enumerates_list {
	EnumeratesNode *first;
	EnumeratesNode *last;
} EnumeratesList;

typedef struct _enumlist_node {
	char *name;
	int istype;
	EnumeratesList *list;
	struct _enumlist_node *next;
} EnumListNode;

typedef struct _enumlist_list {
	EnumListNode *first;
	EnumListNode *last;
} EnumListList;

/* Functions for DEFINES list*/
void InitializeDefinesList(DefinesList *list);
void InsertDefine(DefinesList *list, char *name);
int IsDefine(DefinesList *list, char *name);
void ShowDefines(char *filedefines);

/* Functions for WRITES list*/
void InitializeWritesList(WritesList *list);
void InsertWrite(WritesList *list, char *name);
int IsWrite(WritesList *list, char *name);
void ShowRegsList(RegsList *list);
void ReadWritesFile(WritesList *list, char *name);

/* Functions for registers list*/
void InitializeRegsList(RegsList *list);
void InsertReg(RegsList *list, char *name, char *name2);
char *IsReg(RegsList *list, char *name);
void ShowRegsList(RegsList *list);

/* Functions for ports list*/
void InitializePortList(PortList *list);
void InsertPort(PortList *list, char *name, char *tipo, int size);
void ShowPortList(PortList *list);
void EnumeratePorts(PortList *list);

/* Functions for signals list*/
void InitializeSignalsList(SignalsList *list);
void InsertSignal(SignalsList *list, char *name, int size);
void ShowSignalsList(SignalsList *list, WritesList *WritesList);
int IsWire(char *name, InstancesList *list);

/* Functions for sensitivity list*/
void InitializeSensibilityList(SensibilityList *list);
void InsertSensibility(SensibilityList *list, char *name, char *tipo);
void ShowSensibilityList(SensibilityList *list);

/* Functions for process list*/
void InsertProcess(ProcessList *list, char *name, SensibilityList *SensibilityList, char *tipo);
void ShowProcessList(ProcessList *list);
void ShowProcessCode(ProcessList *list);

/* Functions for instances and binds list*/
void InitializeInstancesList(InstancesList *list);
void InsertInstance(InstancesList *list, char *nameInstance, char *namemodulo);
void InitializeBindsList(BindsList *list);
void InsertBind(BindsList *list, char *namePort, char *namebind);
void ShowInstancedModules(InstancesList *list);

/* Functions for enumerates list*/
void InitializeEnumeratesList(EnumeratesList *list);
void InsertEnumerates(EnumeratesList *list, char *name);
int ShowEnumeratesList(EnumeratesList *list);

/*Functions of list of enumerates list*/
void InitializeEnumListList(EnumListList *list);
void InsertEnumList(EnumListList *list, EnumeratesList *enumlist, char *name, int istype);
void ShowEnumListList(EnumListList *list);
int findEnumList(EnumListList *list, char *name);
int findEnumerateLength(EnumListList *list, int offset);
