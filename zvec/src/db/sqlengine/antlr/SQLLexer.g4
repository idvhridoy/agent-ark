lexer grammar SQLLexer;

channels{COMMENTS}

OR:                           'OR';
AND:                          'AND';
NOT:                          'NOT';
IN:                           'IN';
CONTAIN_ALL:                  'CONTAIN_ALL';
CONTAIN_ANY:                  'CONTAIN_ANY';
BETWEEN:                      'BETWEEN';
LIKE:                         'LIKE';
WHERE:						            'WHERE';
SELECT:						            'SELECT';
FROM:                         'FROM';
AS:							              'AS';
BY:							              'BY';
ORDER:						            'ORDER';
ASC:						              'ASC';
DESC:						              'DESC';
LIMIT:						            'LIMIT';
TRUE_V:                         'TRUE';
FALSE_V:                        'FALSE';
IS:                           'IS';
NULL_V:                         'NULL';

fragment
UNSIGNED_INTEGER: UNSIGNED_INTEGER_FRAGMENT;
INTEGER: MINUS_SIGN? UNSIGNED_INTEGER;

fragment
APPROXIMATE_NUM_LIT: FLOAT_FRAGMENT ('E' ('+'|'-')? (FLOAT_FRAGMENT | UNSIGNED_INTEGER_FRAGMENT))? ('D' | 'F')?;
FLOAT: MINUS_SIGN? APPROXIMATE_NUM_LIT;

SQUOTA_STRING: '\'' (~('\'' | '\\') | '\\'. )* '\'';
DQUOTA_STRING: '"' (~('"' | '\\') | '\\'. )* '"';


DOT: '.';
LP: '(';
RP: ')';
LMP: '[';
RMP: ']';
ASTERISK: '*';
PLUS_SIGN: '+';
MINUS_SIGN: '-';
COMMA: ',';
SOLIDUS: '/';
MOD: '%';
AT_SIGN: '@';
ASSIGN_OP: ':=';
SHARP_SIGN: '#';

COLON: ':';
SEMI: ';';
LE_OP: '<=';
GE_OP: '>=';
NE_OP: '!=';
CARET_OP: '^';
TILDE_OP: '~';
L_OP: '<';
G_OP: '>';
E_OP: '=';
CONCAT_OP: '||';
UNDERSCORE: '_';

SPACES: [ \t\r\n]+ -> skip;

fragment
SIMPLE_LETTER
    : [A-Z]
    ;

fragment
UNSIGNED_INTEGER_FRAGMENT: [0-9]+ ;

fragment
FLOAT_FRAGMENT
    : UNSIGNED_INTEGER* '.'? UNSIGNED_INTEGER+
    ;


VECTOR
    : LMP (MINUS_SIGN|UNSIGNED_INTEGER_FRAGMENT|FLOAT_FRAGMENT|','| SPACES)+ RMP
    ;

SINGLE_LINE_COMMENT: '--' ~('\r' | '\n')* (NEWLINE | EOF)   -> channel(COMMENTS);
MULTI_LINE_COMMENT: '/*' .*? '*/'                           -> channel(COMMENTS);

fragment
NEWLINE: '\r'? '\n';

REGULAR_ID: (SIMPLE_LETTER | '_' | '-' | [0-9])+;


