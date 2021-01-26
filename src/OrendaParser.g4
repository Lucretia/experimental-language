parser grammar OrendaParser;

options {
    tokenVocab = OrendaLexer;
}

source_unit             :   (module | main_function_decl) NL* EOF
                        ;

module                  :   NL* import_list? NL*
                            UNSAFE? MODULE qualified_identifier IS NL*
                                (declarations NL*)*
                            END qualified_identifier NL*
                        ;

import_list             :   IMPORT qualified_identifier (AS ID)* (COMMA NL*
                                   qualified_identifier (AS ID)* )+ NL*
                        ;

qualified_identifier    :   (ID DOT)* ID ;

declarations            :   type_decl
                        |   object_decl
                        |   function_decl
                        ;

// TODO - Check there is no receiver for a main function.
main_function_decl      :   function_decl ;

// TODO - This enables nested functions, do we want them to allow receivers?
function_decl           :   FUNCTION receiver? ID formal_params? IS NL*
                                (declarations | statements NL*)*
                            END ID NL*
                        ;

formal_params           :   LEFT_PAREN (NL* formal_parameter (COMMA NL* formal_parameter)* NL*)* RIGHT_PAREN
                                (NL* COLON NL* qualified_identifier)* ;

formal_parameter        :   ID (COMMA ID)* COLON (IN | IN OUT | OUT) type ;

receiver                :   LEFT_PAREN ID COLON ID RIGHT_PAREN ;

type_decl               :   TYPE ID IS type ;

type                    :   qualified_identifier
                        |   array_type
                        |   record_type
                        ;

array_type              :   ARRAY NL* (LEFT_BRACKET NL* constant_expr (COMMA NL* constant_expr)* NL* RIGHT_BRACKET)? NL* OF type
                        ;

record_type             :   RECORD NL* (LEFT_PAREN qualified_identifier RIGHT_PAREN)? NL*
                                (field_list NL*)+
                            END
                        ;

field_list              :   identifier_list COLON type ;

// Objects.
object_decl             :   identifier_list COLON MUTABLE? type ASSIGNMENT expr_list;

identifier_list         :   ID (COMMA ID)* ;

// Statements.
statements              :   statement NL* (statement NL*)* ;

statement               :   assignment_stmt
                        |   function_call_stmt
                        |   if_statement_stmt
                        |   case_stmt
                        |   loop_stmt
                        |   exit_stmt
                        ;

assignment_stmt         :   designator NL* ASSIGNMENT expression ;

function_call_stmt      :   designator (LEFT_PAREN expr_list? RIGHT_PAREN)? ;

// TODO - Add labels to beginning and end of statement blocks.
if_statement_stmt       :   IF expression THEN
                                statements
                            (ELSIF expression THEN
                                statements)*
                            (ELSE
                                statements)?
                            END IF
                        ;

case_stmt               :   CASE expression IN
                                case_options+
                            (ELSE
                                statements)?
                            END CASE
                        ;

case_options            :   WHEN (case_labels (COMMA case_labels)* RIGHT_ARROW
                                statements)?
                        ;

case_labels             :   constant_expr (DIARESIS constant_expr)? ;

loop_stmt               :   loop_scheme? LOOP NL*
                                (declarations | statements NL*)*
                            END LOOP
                        ;

loop_scheme             :   WHILE expression NL*
                        |   FOR ID IN expression DIARESIS expression NL* REVERSE? NL* (BY constant_expr)? NL*
                        ;

exit_stmt               :   EXIT WHEN expression NL* ;

// Expressions.
constant_expr           :   expression ;

expression              :   NL* simple_expr (relation simple_expr)* ;

simple_expr             :   NL* (PLUS | MINUS)? term (add_op term)* ;

term                    :   NL* factor (mul_op factor)* ;

factor                  :   designator (LEFT_PAREN expr_list? RIGHT_PAREN)?
                        |   INTEGER_LITERAL
                        |   BASED_LITERAL
                        |   BINARY_LITERAL
                        |   OCTAL_LITERAL
                        |   HEX_LITERAL
                        |   REAL_LITERAL
                        |   RUNE_LITERAL
                        |   STRING_LITERAL
                        // |   "null"
                        // |   set
                        |   LEFT_PAREN expression RIGHT_PAREN
                        |   NOT factor
                        ;

// set                     :   '{' (element (COMMA element)*)? '}' ;

// element                 :   expression (DIARESIS expression)? ;

relation                :   EQUALS
                        |   NOT_EQUALS
                        |   LESS_THAN
                        |   LT_EQUALS
                        |   GREATER_THAN
                        |   GT_EQUALS
                        |   IN
                        |   IS
                        ;

add_op                  :   PLUS
                        |   MINUS
                        |   OR
                        ;

mul_op                  :   TIMES
                        |   DIVIDE
                        |   DIV
                        |   MOD
                        |   AND
                        ;

designator              :   qualified_identifier (DOT ID
                                                 | LEFT_BRACKET expr_list RIGHT_BRACKET
                                                 | LEFT_PAREN qualified_identifier RIGHT_PAREN)* ;

expr_list               :   expression (COMMA expression)* ;
