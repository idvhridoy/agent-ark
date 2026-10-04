parser grammar SQLParser;

options {tokenVocab=SQLLexer;}

swallow_to_semi
    : ~SEMI+
    ;

compilation_unit
    : (unit_statement (SOLIDUS | SEMI)?)+ EOF
    ;

logic_expr_unit
    : logic_expr EOF
    ;

unit_statement
    : dql_statement
    ;

where_clause
    : WHERE logic_expr
    ;

logic_expr
    : relation_expr
    | logic_expr AND logic_expr
    | logic_expr OR logic_expr
    | enclosed_expr
    ;

enclosed_expr
    : LP logic_expr RP
    ;

relation_expr
    : identifier rel_oper value_expr
    | identifier LIKE value_expr
    | identifier NOT? IN LP in_value_expr_list RP
     //LMP'[' RMP']' only used in vector representation
    | identifier NOT? (CONTAIN_ALL | CONTAIN_ANY) LP in_value_expr_list? RP
    | identifier IS NOT? NULL_V
    | function_call rel_oper value_expr
    ;

rel_oper
    : E_OP
    | ne_op
    | L_OP
    | G_OP
    | le_op
    | ge_op
    ;

value_expr
    : constant
    | function_call
    ;

in_value_expr_list
    : in_value_expr (COMMA in_value_expr)*
    ;

in_value_expr
    : constant_num_and_str
    | bool_value
    ;

constant
    : numeric
    | quoted_string
    | vector_expr
    | bool_value
    ;

constant_num_and_str
    : numeric
    | quoted_string
    ;

matrix
    : LMP VECTOR (COMMA VECTOR)* RMP
    ;

vector_expr
    : VECTOR
    | matrix
    ;

function_value_expr
    : value_expr
    | identifier
    ;

function_call
    : identifier LP (function_value_expr (COMMA function_value_expr)*)? RP
    ;

dql_statement
    : select_statement
    ;

select_statement
    : SELECT selected_elements from_clause where_clause? order_by_clause? limit_clause?
    ;

selected_elements
    : selected_element (COMMA selected_element)*
    ;

selected_element
    : ASTERISK
    | field_name AS? field_alias?
    ;

from_clause
    : FROM tableview_name
    ;

order_by_clause
    : ORDER BY order_by_element (COMMA order_by_element)*
    ;

order_by_element
    : field_name (ASC | DESC)?
    ;

limit_clause
    : LIMIT int_value
    ;


// $>

/********* schema objects names *********/


tableview_name
    : identifier
    ;

field_name
    : identifier
    ;

table_alias
    : identifier
    ;

field_alias
    : AS? identifier
    ;

numeric
    : int_value
    | float_value
    ;

int_value
    : INTEGER
    ;

float_value
    : FLOAT
    ;

quoted_string
    : SQUOTA_STRING
	| DQUOTA_STRING
    ;
bool_value
	: TRUE_V
	| FALSE_V
	;

identifier
    : regular_id
    ;

ne_op
    : NE_OP
    ;

ge_op
    : GE_OP
    | G_OP E_OP
    ;

le_op
    : LE_OP
    | L_OP E_OP
    ;

regular_id
    : REGULAR_ID
	| OR
	| AND
	| NOT
	| IN
	| BETWEEN
	| LIKE
	| WHERE
	| SELECT
	| AS
	| BY
	| ORDER
	| ASC
	| DESC
	| LIMIT
	;
