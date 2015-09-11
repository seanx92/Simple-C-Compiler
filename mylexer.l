%{
/****************************************************************************
mylexer.l
ParserWizard generated Lex file.
����:NKU Jackshen
Date: 2008��12��14��
****************************************************************************/

#include "myparser.h"

#define MAXCHILDREN 4 //ÿһ���������ӵ�еĺ��ӽ���������

#define IDNUMMAX  100  //�ɴ洢�����������Ŀ

#define LETNUMMAX 999  //�洢�������ֵ������С


//������ű�Ԫ�ص����ݽṹ	
struct entry
{
	char *lexptr;		//��ָ��ָ��������ֵĴ洢λ��
	
	int  type;			//�ñ�������÷��ŵ�����(char��,bool��,int�ͻ�float��)(1:char,2:bool,3:int,4:float)
	
	float   token;		//�ı�������÷��ŵ�ֵ(��Ϊfloat�ͣ�����type��������)
};
	
extern entry symtable[IDNUMMAX];//������ű�

extern char  lexemes[LETNUMMAX];//����������ֵ�ʵ�ʴ洢����

extern int lastentry;    //symtable��������õ�λ��

int   lastchar = -1;	 //lexemes��������õ�λ��




//����������ö������
typedef enum nodeKind 
{	
	kind_prog,				//prog
	kind_lines,             //lines
	kind_expr,				//expr
	kind_stmt,				//stmt
	kind_rela_stmt,			//rela_stmt
	kind_type,				//type
	kind_const,				//const
	kind_ID,				//ID(��ʾ��)
	kind_const_value,		//����(���ַ�����:COUNTCHAR,�����ͳ���:true,false,���ͳ���:COUNTINTNUM,���㳣��:COUNTFLOATNUM)
}   NodeKind ;					
	

		
//���������ṹ
typedef struct treeNode
{   
    treeNode * child[MAXCHILDREN]; //ָ���亢�ӽ���ָ��
	
	treeNode * sibling;			  //����ָ�������ֵܽ���ָ��
	
	
	int Currnode_number;			   //����ý��ı��
	
	int lineno;					   //����ĳЩ����Ӧ�û�������к�	
	
	
	NodeKind nodekind;  //�������,ȡֵ��ΧΪNodeKind�е�ֵ
	
	int nodekind_kind;	//����һ��NodeKind����������������ͣ������(��nodekindȡkind_type����ֵʱ
	                    //�������nodekind_kindΪ1ʱ����ʾ��Ӧ�Ľ��Ϊchar��,nodekind_kindΪ2ʱ,��ʾ��Ӧ�Ľڵ�Ϊbool��.....)

	int stmt_type;		//��nodekindΪkind_stmtʱ,����ʽȡֵ���ñ�����ֵ��Ч.����stmt����ʽ������
	                    //(stmt_typeΪ1ʱ����ʾ��Ӧ��stmt����ʽΪchar��;Ϊ2ʱ����ʾ��Ϊbool��;Ϊ3ʱ����Ϊint��;Ϊ4ʱ����ʾ��Ϊfloat��)
	
	float node_value;	//�����ΪҶ���,����Ϊkind_node_valueʱ,�������泣����ֵ.
						//��nodekind_kindΪ1ʱ,��node_value��floatǿ��ת��Ϊint��,Ȼ��ȡ��Ӧ��char���ַ�;
						//��nodekind_kindΪ2ʱ,��node_value��floatǿ��ת��Ϊint��,��ת��Ϊbool��;
						//��nodekind_kindΪ3ʱ,��node_value��floatǿ��ת��Ϊint��
						//�����Ϊkind_stmtʱ,�����������ʽ��ֵ,��ֵ�ɽ��stmt_typeת��Ϊ����ʽ����ʵֵ	 		
						//�����λkind_IDʱ,��������ID��Ӧ���ű��е��±�
}	TreeNode;



TreeNode * lnew_treeNode;//	��������һ���µ��﷨�����

TreeNode * lnew_TreeNode();//�ú�������һ�������,�����ؽ��ָ��,ͬʱ��ɽ�����ݳ�ʼ��
	
void error(char*m);	
int lookup(char*s);
int insert(char*s);

float change_to_float(char*m,int a);//�ú���������a��ȡֵ���ַ���ת��Ϊ��Ӧ��float��ֵ
	
%}


/////////////////////////////////////////////////////////////////////////////
// declarations section

// lexical analyser name
%name mylexer

// class definition
{
	// place any extra class members here
}

// constructor
{
	// place any extra initialisation code here
}

// destructor
{
	// place any extra cleanup code here
}

digit       [0-9]
nonzerodig  [1-9]
letter      [a-zA-Z_]	
whitespace  [ |\t]+

// place any declarations here



%%

/////////////////////////////////////////////////////////////////////////////
// rules section

%{
	// extract yylval for use later on in actions
	YYSTYPE YYFAR& yylval = *(YYSTYPE YYFAR*)yyparserptr->yylvalptr;
%}

// place your Lex rules here

int		{return(INT);}
void    {return(VOID);} //void
main    {return(MAIN);} //main
char    {return(CHAR);}//char
flaot   {return(FLOAT);}//float
bool    {return(BOOL);}//bool
if		{return(IF);}//if
else	{return(ELSE);}//else
while   {return(WHILE);}//}//while
for     {return(FOR);}//for
"("		{return(LSBRA);}//'('
")"		{return(RSBRA);}//')'	
"{"		{return(LLSBRA);}//'{'	
"}"		{return(RLSBRA);}//'}'	
";"		{return(SEMIC);}//';'	
"+"     {return(ADD);}//'+'
"-"		{return(SUB);}//'-'
"*"		{return(MUL);}//'*'	
"/"     {return(DIV);}//'/'
"%"		{return(PERC);}//'%'
"++"    {return(DADD);}//'++'
--		{return(DSUB);}//'--'
">"	    {return(GREAT);}//'>'
"<"		{return(LESS);}//'<'
"=="	{return(EQU);}//'=='
">="	{return(GEQU);}//'>='
"<="	{return(LEQU);}//'<='
"!="	{return(NEQU);}//'!='
"!"		{return(NOT);}//'!'	
"&&"	{return(AND);}//'&&'
"||"	{return(OR);}//'||'	
"="		{return(EVALU);}//��ֵ
"//"	{
			char c;
		
			c = input();
			
			while(true)
			{
				c = input();
				
				if(c == '\n')
				{
					break;
				}
				
			}	
		}
"/*"    {
            char c;
        
            label:
        
            do{
        
                 c = input();
        
              }while(c != '*');
            
            do
            {
                c = input();
        
                if(c == '/')
        
                    break;
        
                if(c != '*')
        
                    goto label;
        
            }while(c == '*');
            
        }
        
"\n"	{;}	//�س��� 	
	
'({letter}|{digit})'						
{
	yylval = lnew_TreeNode();//�������ڵ�
	yylval->nodekind = kind_const_value;//�ڵ�����Ϊ��������
	yylval->node_value = change_to_float(yytext,1);
	return(COUNTCHAR);
}
true										
{
	yylval = lnew_TreeNode();
	yylval->nodekind = kind_const_value;
	yylval->node_value = change_to_float(yytext,2);
	return(TRUE);
}
false										
{
	yylval = lnew_TreeNode();
	yylval->nodekind = kind_const_value;
	yylval->node_value = change_to_float(yytext,3);
	return(FALSE);
}	
({nonzerodig}{digit}*)|0					
{
	yylval = lnew_TreeNode();
	yylval->nodekind = kind_const_value;
	yylval->node_value = change_to_float(yytext,4);
	return(COUNTINTNUM);
}
(({nonzerodig}{digit}*)|0).{digit}+			
{
	yylval = lnew_TreeNode();
	yylval->nodekind = kind_const_value;
	yylval->node_value = change_to_float(yytext,5);
	return(COUNTFLOATNUM);
}
{letter}({letter}|{digit})*					
{
	int a=lookup(yytext);//�����ű����Ƿ��Ѵ���
	
	if(a==0)//���ű����粻���ڸ��ַ�
	{
		a=insert(yytext);
	}
	
	yylval = lnew_TreeNode();
	yylval->nodekind = kind_ID;
	yylval->node_value = float(a);
	return(ID);
}
{whitespace}								
{
	;//do nothing
}

%%

/////////////////////////////////////////////////////////////////////////////
// programs section
TreeNode * lnew_TreeNode(void)				//�ú�������һ�������,�����ؽ��ָ��,ͬʱ��ɽ�����ݳ�ʼ��
{	
	lnew_treeNode = new(TreeNode) ;
	
	for(int i=0;i<MAXCHILDREN;i++)		//Ϊָ���亢�ӽ���ָ�븳��ֵ
	{
		lnew_treeNode->child[i] = NULL;
	}
	
	lnew_treeNode->sibling = NULL;		//Ϊָ�������ֵܽ���ָ�븳��ֵ	
	
	lnew_treeNode->lineno = 0;			//Ϊ����Ӧ�û�������кŸ���ֵ
	
	lnew_treeNode->Currnode_number = 0;
	
	lnew_treeNode->nodekind_kind = 0;//ΪNodeKind������������ı�Ÿ���ֵ,��ȷ�ı��Ӧ��Ϊ������
	
	lnew_treeNode->stmt_type = 0; //Ϊ����stmt����ʽ�����͵ı�������ֵ,��ȷstmt����ʽ����ӦΪ1-4֮���������
	
	return lnew_treeNode;
}


float change_to_float(char*m,int a)//�ú�������a��ȡֵ�����ַ���ת��Ϊ��Ӧ��float�͵�ֵ
{
	float b = 0;
	float c = 0;
	int i = 0;
	int j = 0;
	
	switch(a)
	{
		case 1:						//�����ַ�����(����Ӧ��ֵΪ1)ת��Ϊ��Ӧ��ASCII��,Ȼ���һ��ת��Ϊfloat��ֵ,������
			b = float(int(*m));						
			break;
		case 4:						//��int�ͣ�����Ӧ��ֵΪ4��������Ӧ���ַ���ת��Ϊ��Ӧ��float��ֵ,
			for(i = 0;m[i]!='\0';i++)					
			{
				b = b * 10 + m[i] - '0'; 
			}
			break;
		case 5:						//��float�ͣ�����Ӧ��ֵΪ5��������Ӧ���ַ���ת��Ϊ��Ӧ��float��ֵ
			for(i = 0;(m[i]!='.')&&(m[i]!='/0');i++ )
			{
				b = b * 10 + m[i] - '0';
			}
			for(;m[i]!='/0';i++)
			{
				i++;
				c = c * 10 + m[i] - '0';
				j++; 
			}
			for(;j>0;j--)
			{
				c = c / 10;
			}
			b = b + c;
			break;
		default:
			error("����������");
	}
	return b;
}


//һ������ĺ��� 
void error(char*m)
{
	cout<<m;
	exit(1);
}

int lookup(char*s)
{
	int p;
	
	for(p=1;p<=lastentry;p++)
	{
		if(strcmp(symtable[p].lexptr,s)==0)
		{
			return p;
		}
	}
	
	return 0;
}

int insert(char*s)
{
	int len;
	
	len=strlen(s);
	
	if(lastentry+1>=IDNUMMAX)
	{
		error("symbol table full \n");
	}
	
	if(lastchar+len+1>=LETNUMMAX)
	{
		error("lexemes array full \n");
	}
	
	lastentry++;
	
	symtable[lastentry].lexptr=lexemes+lastchar+1;
	
	lastchar=lastchar+len+1;
	
	strcpy(symtable[lastentry].lexptr,s);
	
	return lastentry;
}