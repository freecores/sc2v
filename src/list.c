/* -----------------------------------------------------------------------------
 *
 *  SystemC to Verilog Translator v0.2
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

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "list.h"

void
InitializeDefinesList (DefinesList * list)
{

  DefineNode *first;

  first = (DefineNode *) malloc (sizeof (DefineNode));

  list->first = first;

  list->last = NULL;

}


void
InsertDefine (DefinesList * list, char *name)
{

  if (list->last == NULL)	//list empty
    {

      list->first->name = (char *) malloc (256 * sizeof (char));

      strcpy (list->first->name, name);

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      DefineNode *nuevo;

      nuevo = (DefineNode *) malloc (sizeof (DefineNode));

      nuevo->name = (char *) malloc (256 * sizeof (char));

      strcpy (nuevo->name, name);

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }
}

int
IsDefine (DefinesList * list, char *name)
{

  DefineNode *auxwrite = list->first;


  if (list->last == NULL)

    {

      return 0;

    }

  else

    {

      while (1)

	{

	  if ((strcmp (name, auxwrite->name) == 0))

	    {

	      return 1;

	    }

	  else if (auxwrite->next != NULL)

	    {

	      auxwrite = auxwrite->next;

	    }

	  else

	    {

	      break;

	    }

	}

    }

  return 0;

}


void
ShowDefines (char *filedefines)
{

  int readok;

  char *auxchar;

  FILE *file;


  file = fopen (filedefines, (char *) "r");


  while (1)

    {

      readok = fread ((void *) &auxchar, sizeof (char), 1, file);

      if (readok)

	printf ("%c", auxchar);

      else

	break;

    }

}


void
InitializeWritesList (WritesList * list)
{

  WriteNode *first;

  first = (WriteNode *) malloc (sizeof (WriteNode));

  list->first = first;

  list->last = NULL;

}


void
InsertWrite (WritesList * list, char *name)
{

  if (list->last == NULL)	//list empty
    {

      list->first->name = (char *) malloc (256 * sizeof (char));

      strcpy (list->first->name, name);

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      WriteNode *nuevo;

      nuevo = (WriteNode *) malloc (sizeof (WriteNode));

      nuevo->name = (char *) malloc (256 * sizeof (char));

      strcpy (nuevo->name, name);

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }
}

int
IsWrite (WritesList * list, char *name)
{

  WriteNode *auxwrite = list->first;


  if (list->last == NULL)

    {

      return 0;

    }

  else

    {

      while (1)

	{

	  if ((strcmp (name, auxwrite->name) == 0))

	    {

	      return 1;

	    }

	  else if (auxwrite->next != NULL)

	    {

	      auxwrite = auxwrite->next;

	    }

	  else

	    {

	      break;

	    }

	}

    }

  return 0;

}


void
ShowWritesList (WritesList * list)
{

  if (list->last != NULL)	//list not empty
    {

      WriteNode *aux = list->first;

      while (1)

	{

	  printf ("%s\n", aux->name);

	  if (aux->next == NULL)

	    {

	      break;

	    }

	  aux = aux->next;

	}

    }

}


void
ReadWritesFile (WritesList * list, char *name)
{

  char *leido;

  int ret;

  FILE *file_writes;

  file_writes = fopen (name, (char *) "r");


  leido = (char *) malloc (256 * sizeof (char));


  while (1)

    {

      ret = fscanf (file_writes, "%s", leido);

      if (ret == EOF)

	break;

      InsertWrite (list, leido);

    }



}


void
InitializeRegsList (RegsList * list)
{

  RegNode *first;

  first = (RegNode *) malloc (sizeof (RegNode));

  list->first = first;

  list->last = NULL;

}


void
InsertReg (RegsList * list, char *name, char *name2)
{

  if (list->last == NULL)

    {

      list->first->name = (char *) malloc (256 * sizeof (char));

      list->first->name2 = (char *) malloc (256 * sizeof (char));

      strcpy (list->first->name, name);

      strcpy (list->first->name2, name2);

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      RegNode *nuevo;

      nuevo = (RegNode *) malloc (sizeof (RegNode));

      nuevo->name = (char *) malloc (256 * sizeof (char));

      nuevo->name2 = (char *) malloc (256 * sizeof (char));

      strcpy (nuevo->name, name);

      strcpy (nuevo->name2, name2);

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }
}


/* Looks if a WORD of func.y file is a register of the process*/
char *
IsReg (RegsList * list, char *name)
{

  RegNode *auxreg = list->first;


  if (list->last == NULL)

    {

      return NULL;

    }

  else

    {

      while (1)

	{

	  if ((strcmp (name, auxreg->name) == 0))

	    {

	      return auxreg->name2;

	    }

	  else if (auxreg->next != NULL)

	    {

	      auxreg = auxreg->next;

	    }

	  else

	    {

	      break;

	    }

	}

    }

  return NULL;

}


void
ShowRegsList (RegsList * list)
{

  if (list->last != NULL)

    {

      RegNode *aux = list->first;

      while (1)

	{

	  printf ("%s\t", aux->name);

	  printf ("%s;\n", aux->name2);

	  if (aux->next == NULL)

	    {

	      break;

	    }

	  aux = aux->next;

	}

    }

}


void
InitializePortList (PortList * list)
{

  PortNode *first;

  first = (PortNode *) malloc (sizeof (PortNode));

  list->first = first;

  list->last = NULL;

}


void
InsertPort (PortList * list, char *name, char *tipo, int size)
{

  if (list->last == NULL)

    {

      list->first->name = name;

      list->first->tipo = tipo;

      list->first->size = size;

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      PortNode *nuevo;

      nuevo = (PortNode *) malloc (sizeof (PortNode));

      nuevo->name = name;

      nuevo->tipo = tipo;

      nuevo->size = size;

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }

}


void
ShowPortList (PortList * list)
{

  if (list->last != NULL)

    {

      PortNode *aux = list->first;

      while (1)

	{

	  printf ("%s ", aux->tipo);

	  if (aux->size != 0 && aux->size != 1)

	    {

	      printf ("[%d:0] ", (-1 + aux->size));

	    }

	  printf ("%s;\n", aux->name);

	  if (aux->next == NULL)

	    {

	      break;

	    }

	  aux = aux->next;

	}

    }

}


void
RegOutputs (PortList * list)
{

  if (list->last != NULL)

    {

      PortNode *aux = list->first;

      while (1)

	{

	  if (strcmp (aux->tipo, (char *) "output") == 0)

	    {

	      printf ("reg ");

	      if (aux->size != 0 && aux->size != 1)

		{

		  printf ("[%d:0] ", (-1 + aux->size));

		}

	      printf ("%s;\n", aux->name);

	    }

	  if (aux->next == NULL)

	    {

	      break;

	    }

	  aux = aux->next;

	}

    }

}


void
EnumeratePorts (PortList * list)
{

  if (list->last != NULL)

    {

      PortNode *aux = list->first;

      while (1)

	{

	  if (aux->next == NULL)

	    {

	      printf ("%s", aux->name);

	      break;

	    }

	  else

	    {

	      printf ("%s,", aux->name);

	      aux = aux->next;

	    }

	}

    }

}


void
InitializeSignalsList (SignalsList * list)
{

  SignalNode *first;

  first = (SignalNode *) malloc (sizeof (SignalNode));

  list->first = first;

  list->last = NULL;

}


void
InsertSignal (SignalsList * list, char *name, int size)
{

  if (list->last == NULL)

    {

      list->first->name = name;

      list->first->size = size;

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      SignalNode *nuevo;

      nuevo = (SignalNode *) malloc (sizeof (SignalNode));

      nuevo->name = name;

      nuevo->size = size;

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }

}


void
ShowSignalsList (SignalsList * list, WritesList * WritesList)
{

  if (list->last != NULL)

    {

      SignalNode *aux = list->first;

      while (1)

	{

	  if (IsWrite (WritesList, aux->name))

	    {

	      printf ("reg ");

	      if (aux->size != 0 && aux->size != 1)

		{

		  printf ("[%d:0] ", (-1 + aux->size));

		}

	      printf ("%s;\n", aux->name);

	    }

	  else

	    {

	      printf ("wire ");

	      if (aux->size != 0 && aux->size != 1)

		{

		  printf ("[%d:0] ", (-1 + aux->size));

		}

	      printf ("%s;\n", aux->name);

	    }


	  if (aux->next == NULL)

	    {

	      break;

	    }

	  aux = aux->next;

	}

    }

}



/* Decides if a signal is a wire or a reg*/
int
IsWire (char *name, InstancesList * list)
{

  InstanceNode *auxinstance = list->first;

  BindNode *auxbind;

  if (list->last == NULL)

    {

      return 0;

    }

  else

    {

      while (1)

	{

	  auxbind = auxinstance->bindslist->first;

	  while (1)

	    {

	      if ((strcmp (name, auxbind->namebind) == 0))

		{

		  return 1;

		}

	      else if (auxbind->next != NULL)

		{

		  auxbind = auxbind->next;

		}

	      else

		{

		  break;

		}

	    }

	  if (auxinstance->next != NULL)

	    {

	      auxinstance = auxinstance->next;

	    }

	  else

	    {

	      break;

	    }

	}

    }

  return 0;

}


void
InitializeSensibilityList (SensibilityList * list)
{

  SensibilityNode *first;

  first = (SensibilityNode *) malloc (sizeof (SensibilityNode));

  list->first = first;

  list->last = NULL;

}


void
InsertSensibility (SensibilityList * list, char *name, char *tipo)
{

  if (list->last == NULL)

    {

      list->first->name = name;

      list->first->tipo = tipo;

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      SensibilityNode *nuevo;

      nuevo = (SensibilityNode *) malloc (sizeof (SensibilityNode));

      nuevo->name = name;

      nuevo->tipo = tipo;

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }

}


void
ShowSensibilityList (SensibilityList * list)
{

  if (list->last != NULL)

    {

      SensibilityNode *aux = list->first;

      while (1)

	{

	  if (!strcmp (aux->tipo, "posedge")
	      || !strcmp (aux->tipo, "negedge"))

	    printf (" %s", aux->tipo);

	  if (aux->next == NULL)

	    {

	      printf (" %s", aux->name);

	      break;

	    }

	  else

	    {

	      printf (" %s or", aux->name);

	    }

	  aux = aux->next;

	}

    }

}



void
InitializeProcessList (ProcessList * list)
{

  ProcessNode *first;

  first = (ProcessNode *) malloc (sizeof (ProcessNode));

  list->first = first;

  list->last = NULL;

}


void
InsertProcess (ProcessList * list, char *name,
	       SensibilityList * SensibilityList, char *tipo)
{

  if (list->last == NULL)

    {

      list->first->name = name;

      list->first->tipo = tipo;

      list->first->list = SensibilityList;

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      ProcessNode *nuevo;

      nuevo = (ProcessNode *) malloc (sizeof (ProcessNode));

      nuevo->name = name;

      nuevo->tipo = tipo;

      nuevo->list = SensibilityList;

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }

}


void
ShowProcessList (ProcessList * list)
{

  if (list->last != NULL)

    {

      ProcessNode *aux = list->first;

      while (1)

	{

	  printf ("%s: always @(", aux->name);

	  ShowSensibilityList (aux->list);

	  printf (")\n");

	  if (aux->next == NULL)

	    {

	      break;

	    }

	  aux = aux->next;

	}

    }

}


void
ShowProcessCode (ProcessList * list)
{

  if (list->last != NULL)

    {

      ProcessNode *aux = list->first;
      FILE *archivo;
      int readok;
      char lookahead;
      char *filename;
      char auxchar;
      char begin[10];


      while (1)
	{
	  printf ("//%s:\n", aux->name);
	  filename = (char *) malloc (256 * sizeof (char));
	  strcpy (filename, aux->name);
	  strcat (filename, (char *) "_regs.sc2v");
	  archivo = fopen (filename, (char *) "r");

	  while (1)
	    {
	      readok = fread ((void *) &auxchar, sizeof (char), 1, archivo);
	      if (readok)
		printf ("%c", auxchar);
	      else
		break;
	    }

	  fclose (archivo);

	  printf ("always @(");

	  ShowSensibilityList (aux->list);

	  printf (" )\n");
	  printf ("   begin\n");
	  strcpy (filename, aux->name);
	  strcat (filename, (char *) ".sc2v");
	  archivo = fopen (filename, (char *) "r");

	  /*Read the initial begin of the file */
	  fscanf (archivo, "%s", begin);

	  readok = fread ((void *) &auxchar, sizeof (char), 1, archivo);

	  /*Trim the beggining of the file */
	  while (auxchar == '\n' || auxchar == ' ' || auxchar == '\t')
	    readok = fread ((void *) &auxchar, sizeof (char), 1, archivo);

	  printf ("\n   %c", auxchar);

	  while (1)
	    {
	      readok = fread ((void *) &auxchar, sizeof (char), 1, archivo);
	      if (readok)
		{
		  if (strcmp (aux->tipo, "comb") == 0 && auxchar == '<')
		    {
		      readok =	fread ((void *) &lookahead, sizeof (char), 1,archivo);

		      if (readok)
			{
			  if (lookahead == '=')
			    {
			      auxchar = lookahead;
			    }
			  else
			    {
			      printf ("%c", auxchar);
			    }
			}
		    }
		  printf ("%c", auxchar);
		}
	      else
		{
		  break;
		}
	    }

	  fclose (archivo);

	  if (aux->next == NULL)
	    {
	      break;
	    }

	  aux = aux->next;

	}

    }

}



void
InitializeInstancesList (InstancesList * list)
{

  InstanceNode *first;

  first = (InstanceNode *) malloc (sizeof (InstanceNode));

  list->first = first;

  list->last = NULL;

}


void
InsertInstance (InstancesList * list, char *nameinstance, char *namemodulo)
{

  if (list->last == NULL)

    {

      list->first->nameinstance = nameinstance;

      list->first->namemodulo = namemodulo;

      list->first->next = NULL;

      list->last = list->first;

      list->last->bindslist = (BindsList *) malloc (sizeof (BindsList));

      list->last->bindslist = (BindsList *) malloc (sizeof (BindsList));

      InitializeBindsList (list->last->bindslist);

    }

  else

    {

      InstanceNode *nuevo;

      nuevo = (InstanceNode *) malloc (sizeof (InstanceNode));

      nuevo->nameinstance = nameinstance;

      nuevo->namemodulo = namemodulo;

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

      list->last->bindslist = (BindsList *) malloc (sizeof (BindsList));

      InitializeBindsList (list->last->bindslist);

    }

}


void
InitializeBindsList (BindsList * list)
{

  BindNode *first;

  first = (BindNode *) malloc (sizeof (BindNode));

  list->first = first;

  list->last = NULL;

}


void
InsertBind (BindsList * list, char *nameport, char *namebind)
{

  if (list->last == NULL)

    {

      list->first->nameport = nameport;

      list->first->namebind = namebind;

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      BindNode *nuevo;

      nuevo = (BindNode *) malloc (sizeof (BindNode));

      nuevo->nameport = nameport;

      nuevo->namebind = namebind;

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }

}


void
ShowInstancedModules (InstancesList * list)
{

  if (list->last != NULL)

    {

      InstanceNode *auxinstance;

      auxinstance = list->first;

      BindNode *auxbind;

      auxbind = auxinstance->bindslist->first;

      while (1)

	{

	  printf ("%s %s (", auxinstance->namemodulo,
		  auxinstance->nameinstance);

	  while (1)

	    {

	      printf (".%s(%s)", auxbind->nameport, auxbind->namebind);

	      if (auxbind->next == NULL)

		{

		  printf (");\n");

		  break;

		}

	      else

		{

		  printf (", ");

		  auxbind = auxbind->next;

		}

	    }

	  if (auxinstance->next == NULL)

	    {

	      break;

	    }

	  else

	    {

	      auxinstance = auxinstance->next;

	      auxbind = auxinstance->bindslist->first;

	    }

	}

    }

}



//Enumerates list
void
InitializeEnumeratesList (EnumeratesList * list)
{

  EnumeratesNode *first;

  first = (EnumeratesNode *) malloc (sizeof (EnumeratesNode));

  list->first = first;

  list->last = NULL;

}


void
InsertEnumerates (EnumeratesList * list, char *name)
{

  if (list->last == NULL)

    {

      list->first->name = name;

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      EnumeratesNode *nuevo;

      nuevo = (EnumeratesNode *) malloc (sizeof (EnumeratesNode));

      nuevo->name = name;

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }

}


int
ShowEnumeratesList (EnumeratesList * list)
{

  int i = 0;

  if (list->last != NULL)

    {

      EnumeratesNode *aux = list->first;

      printf ("parameter  %s = 0", aux->name);


      if (aux->next != NULL)
	{

	  printf (",\n");

	  aux = aux->next;

	  i = 1;

	  while (1)

	    {

	      if (aux->next == NULL)

		{

		  printf ("           %s = %d;\n\n", aux->name, i);

		  return (i);

		}

	      else

		{

		  printf ("           %s = %d,\n", aux->name, i);

		}

	      i++;

	      aux = aux->next;

	    }

	}
      else
	{

	  printf (";\n\n");

	  return (i);

	}

    }

}



//List of enumerates list
void
InitializeEnumListList (EnumListList * list)
{

  EnumListNode *first;

  first = (EnumListNode *) malloc (sizeof (EnumListNode));

  list->first = first;

  list->last = NULL;

}


void
InsertEnumList (EnumListList * list, EnumeratesList * enumlist, char *name,
		int istype)
{

  if (list->last == NULL)

    {

      list->first->name = name;

      list->first->istype = istype;

      list->first->list = enumlist;

      list->first->next = NULL;

      list->last = list->first;

    }

  else

    {

      EnumListNode *nuevo;

      nuevo = (EnumListNode *) malloc (sizeof (EnumListNode));

      nuevo->name = name;

      nuevo->istype = istype;

      nuevo->list = enumlist;

      nuevo->next = NULL;

      list->last->next = nuevo;

      list->last = nuevo;

    }

}


void
ShowEnumListList (EnumListList * list)
{

  int items;


  if (list->last != NULL)

    {

      EnumListNode *aux = list->first;

      while (1)

	{

	  items = ShowEnumeratesList (aux->list);


	  //Calculate the number of bits needed to represent the enumerate
	  double bits, bits_round;

	  int bits_i;

	  bits = log ((double) (items + 1)) / log (2.0);

	  bits_i = bits;

	  bits_round = bits_i;

	  if (bits_round != bits)
	    bits_i++;

	  if (bits_i == 0)
	    bits_i = 1;


	  if (!(aux->istype))
	    {

	      if ((bits_i - 1) != 0)

		printf ("reg [%d:0] %s;\n\n", bits_i - 1, aux->name);

	      else

		printf ("reg %s;\n\n", aux->name);

	    }


	  if (aux->next == NULL)

	    {

	      break;

	    }

	  aux = aux->next;

	}

    }

}


int
findEnumList (EnumListList * list, char *name)
{

  int i = 0;

  if (list->last != NULL)

    {

      EnumListNode *aux = list->first;


      while (1)

	{

	  //printf("%s %s %d %d\n", aux->name,name,aux->istype,i);
	  if ((strcmp (aux->name, name) == 0) && ((aux->istype) == 1))
	    {

	      return i;

	    }

	  if (aux->next == NULL)
	    {

	      return -1;

	    }

	  aux = aux->next;

	  i++;

	}

    }
  else

    return -1;

}


int
findEnumerateLength (EnumListList * list, int offset)
{

  int i = 0;

  double bits, bits_round;

  int bits_i;


  if (list->last != NULL)

    {

      i = 0;

      EnumListNode *aux = list->first;

      EnumeratesNode *aux2;


      for (i = 0; i < offset; i++)

	aux = aux->next;


      aux2 = aux->list->first;


      i = 0;

      while (1)

	{

	  i++;

	  if (aux2->next == NULL)
	    {

	      //Calculate the number of bits needed to represent the enumerate
	      bits = log ((double) (i)) / log (2.0);

	      bits_i = bits;

	      bits_round = bits_i;

	      if (bits_round != bits)
		bits_i++;

	      if (bits_i == 0)
		bits_i = 1;

	      return bits_i;

	    }

	  aux2 = aux2->next;


	}

    }

}
