
// Generated from SQLParser.g4 by ANTLR 4.8

#pragma once


#include "antlr4-runtime.h"


namespace antlr4 {


class SQLParser : public antlr4::Parser {
 public:
  enum {
    OR = 1,
    AND = 2,
    NOT = 3,
    IN = 4,
    CONTAIN_ALL = 5,
    CONTAIN_ANY = 6,
    BETWEEN = 7,
    LIKE = 8,
    WHERE = 9,
    SELECT = 10,
    FROM = 11,
    AS = 12,
    BY = 13,
    ORDER = 14,
    ASC = 15,
    DESC = 16,
    LIMIT = 17,
    TRUE_V = 18,
    FALSE_V = 19,
    IS = 20,
    NULL_V = 21,
    INTEGER = 22,
    FLOAT = 23,
    SQUOTA_STRING = 24,
    DQUOTA_STRING = 25,
    DOT = 26,
    LP = 27,
    RP = 28,
    LMP = 29,
    RMP = 30,
    ASTERISK = 31,
    PLUS_SIGN = 32,
    MINUS_SIGN = 33,
    COMMA = 34,
    SOLIDUS = 35,
    MOD = 36,
    AT_SIGN = 37,
    ASSIGN_OP = 38,
    SHARP_SIGN = 39,
    COLON = 40,
    SEMI = 41,
    LE_OP = 42,
    GE_OP = 43,
    NE_OP = 44,
    CARET_OP = 45,
    TILDE_OP = 46,
    L_OP = 47,
    G_OP = 48,
    E_OP = 49,
    CONCAT_OP = 50,
    UNDERSCORE = 51,
    SPACES = 52,
    VECTOR = 53,
    SINGLE_LINE_COMMENT = 54,
    MULTI_LINE_COMMENT = 55,
    REGULAR_ID = 56
  };

  enum {
    RuleSwallow_to_semi = 0,
    RuleCompilation_unit = 1,
    RuleLogic_expr_unit = 2,
    RuleUnit_statement = 3,
    RuleWhere_clause = 4,
    RuleLogic_expr = 5,
    RuleEnclosed_expr = 6,
    RuleRelation_expr = 7,
    RuleRel_oper = 8,
    RuleValue_expr = 9,
    RuleIn_value_expr_list = 10,
    RuleIn_value_expr = 11,
    RuleConstant = 12,
    RuleConstant_num_and_str = 13,
    RuleMatrix = 14,
    RuleVector_expr = 15,
    RuleFunction_value_expr = 16,
    RuleFunction_call = 17,
    RuleDql_statement = 18,
    RuleSelect_statement = 19,
    RuleSelected_elements = 20,
    RuleSelected_element = 21,
    RuleFrom_clause = 22,
    RuleOrder_by_clause = 23,
    RuleOrder_by_element = 24,
    RuleLimit_clause = 25,
    RuleTableview_name = 26,
    RuleField_name = 27,
    RuleTable_alias = 28,
    RuleField_alias = 29,
    RuleNumeric = 30,
    RuleInt_value = 31,
    RuleFloat_value = 32,
    RuleQuoted_string = 33,
    RuleBool_value = 34,
    RuleIdentifier = 35,
    RuleNe_op = 36,
    RuleGe_op = 37,
    RuleLe_op = 38,
    RuleRegular_id = 39
  };

  SQLParser(antlr4::TokenStream *input);
  ~SQLParser();

  virtual std::string getGrammarFileName() const override;
  virtual const antlr4::atn::ATN &getATN() const override {
    return _atn;
  };
  virtual const std::vector<std::string> &getTokenNames() const override {
    return _tokenNames;
  };  // deprecated: use vocabulary instead.
  virtual const std::vector<std::string> &getRuleNames() const override;
  virtual antlr4::dfa::Vocabulary &getVocabulary() const override;


  class Swallow_to_semiContext;
  class Compilation_unitContext;
  class Logic_expr_unitContext;
  class Unit_statementContext;
  class Where_clauseContext;
  class Logic_exprContext;
  class Enclosed_exprContext;
  class Relation_exprContext;
  class Rel_operContext;
  class Value_exprContext;
  class In_value_expr_listContext;
  class In_value_exprContext;
  class ConstantContext;
  class Constant_num_and_strContext;
  class MatrixContext;
  class Vector_exprContext;
  class Function_value_exprContext;
  class Function_callContext;
  class Dql_statementContext;
  class Select_statementContext;
  class Selected_elementsContext;
  class Selected_elementContext;
  class From_clauseContext;
  class Order_by_clauseContext;
  class Order_by_elementContext;
  class Limit_clauseContext;
  class Tableview_nameContext;
  class Field_nameContext;
  class Table_aliasContext;
  class Field_aliasContext;
  class NumericContext;
  class Int_valueContext;
  class Float_valueContext;
  class Quoted_stringContext;
  class Bool_valueContext;
  class IdentifierContext;
  class Ne_opContext;
  class Ge_opContext;
  class Le_opContext;
  class Regular_idContext;

  class Swallow_to_semiContext : public antlr4::ParserRuleContext {
   public:
    Swallow_to_semiContext(antlr4::ParserRuleContext *parent_ctx,
                           size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    std::vector<antlr4::tree::TerminalNode *> SEMI();
    antlr4::tree::TerminalNode *SEMI(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Swallow_to_semiContext *swallow_to_semi();

  class Compilation_unitContext : public antlr4::ParserRuleContext {
   public:
    Compilation_unitContext(antlr4::ParserRuleContext *parent_ctx,
                            size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *EOF();
    std::vector<Unit_statementContext *> unit_statement();
    Unit_statementContext *unit_statement(size_t i);
    std::vector<antlr4::tree::TerminalNode *> SOLIDUS();
    antlr4::tree::TerminalNode *SOLIDUS(size_t i);
    std::vector<antlr4::tree::TerminalNode *> SEMI();
    antlr4::tree::TerminalNode *SEMI(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Compilation_unitContext *compilation_unit();

  class Logic_expr_unitContext : public antlr4::ParserRuleContext {
   public:
    Logic_expr_unitContext(antlr4::ParserRuleContext *parent_ctx,
                           size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Logic_exprContext *logic_expr();
    antlr4::tree::TerminalNode *EOF();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Logic_expr_unitContext *logic_expr_unit();

  class Unit_statementContext : public antlr4::ParserRuleContext {
   public:
    Unit_statementContext(antlr4::ParserRuleContext *parent_ctx,
                          size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Dql_statementContext *dql_statement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Unit_statementContext *unit_statement();

  class Where_clauseContext : public antlr4::ParserRuleContext {
   public:
    Where_clauseContext(antlr4::ParserRuleContext *parent_ctx,
                        size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *WHERE();
    Logic_exprContext *logic_expr();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Where_clauseContext *where_clause();

  class Logic_exprContext : public antlr4::ParserRuleContext {
   public:
    Logic_exprContext(antlr4::ParserRuleContext *parent_ctx,
                      size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Relation_exprContext *relation_expr();
    Enclosed_exprContext *enclosed_expr();
    std::vector<Logic_exprContext *> logic_expr();
    Logic_exprContext *logic_expr(size_t i);
    antlr4::tree::TerminalNode *AND();
    antlr4::tree::TerminalNode *OR();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Logic_exprContext *logic_expr();
  Logic_exprContext *logic_expr(int precedence);
  class Enclosed_exprContext : public antlr4::ParserRuleContext {
   public:
    Enclosed_exprContext(antlr4::ParserRuleContext *parent_ctx,
                         size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *LP();
    Logic_exprContext *logic_expr();
    antlr4::tree::TerminalNode *RP();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Enclosed_exprContext *enclosed_expr();

  class Relation_exprContext : public antlr4::ParserRuleContext {
   public:
    Relation_exprContext(antlr4::ParserRuleContext *parent_ctx,
                         size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    Rel_operContext *rel_oper();
    Value_exprContext *value_expr();
    antlr4::tree::TerminalNode *LIKE();
    antlr4::tree::TerminalNode *IN();
    antlr4::tree::TerminalNode *LP();
    In_value_expr_listContext *in_value_expr_list();
    antlr4::tree::TerminalNode *RP();
    antlr4::tree::TerminalNode *NOT();
    antlr4::tree::TerminalNode *CONTAIN_ALL();
    antlr4::tree::TerminalNode *CONTAIN_ANY();
    antlr4::tree::TerminalNode *IS();
    antlr4::tree::TerminalNode *NULL_V();
    Function_callContext *function_call();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Relation_exprContext *relation_expr();

  class Rel_operContext : public antlr4::ParserRuleContext {
   public:
    Rel_operContext(antlr4::ParserRuleContext *parent_ctx,
                    size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *E_OP();
    Ne_opContext *ne_op();
    antlr4::tree::TerminalNode *L_OP();
    antlr4::tree::TerminalNode *G_OP();
    Le_opContext *le_op();
    Ge_opContext *ge_op();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Rel_operContext *rel_oper();

  class Value_exprContext : public antlr4::ParserRuleContext {
   public:
    Value_exprContext(antlr4::ParserRuleContext *parent_ctx,
                      size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    ConstantContext *constant();
    Function_callContext *function_call();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Value_exprContext *value_expr();

  class In_value_expr_listContext : public antlr4::ParserRuleContext {
   public:
    In_value_expr_listContext(antlr4::ParserRuleContext *parent_ctx,
                              size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    std::vector<In_value_exprContext *> in_value_expr();
    In_value_exprContext *in_value_expr(size_t i);
    std::vector<antlr4::tree::TerminalNode *> COMMA();
    antlr4::tree::TerminalNode *COMMA(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  In_value_expr_listContext *in_value_expr_list();

  class In_value_exprContext : public antlr4::ParserRuleContext {
   public:
    In_value_exprContext(antlr4::ParserRuleContext *parent_ctx,
                         size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Constant_num_and_strContext *constant_num_and_str();
    Bool_valueContext *bool_value();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  In_value_exprContext *in_value_expr();

  class ConstantContext : public antlr4::ParserRuleContext {
   public:
    ConstantContext(antlr4::ParserRuleContext *parent_ctx,
                    size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    NumericContext *numeric();
    Quoted_stringContext *quoted_string();
    Vector_exprContext *vector_expr();
    Bool_valueContext *bool_value();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  ConstantContext *constant();

  class Constant_num_and_strContext : public antlr4::ParserRuleContext {
   public:
    Constant_num_and_strContext(antlr4::ParserRuleContext *parent_ctx,
                                size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    NumericContext *numeric();
    Quoted_stringContext *quoted_string();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Constant_num_and_strContext *constant_num_and_str();

  class MatrixContext : public antlr4::ParserRuleContext {
   public:
    MatrixContext(antlr4::ParserRuleContext *parent_ctx, size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *LMP();
    std::vector<antlr4::tree::TerminalNode *> VECTOR();
    antlr4::tree::TerminalNode *VECTOR(size_t i);
    antlr4::tree::TerminalNode *RMP();
    std::vector<antlr4::tree::TerminalNode *> COMMA();
    antlr4::tree::TerminalNode *COMMA(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  MatrixContext *matrix();

  class Vector_exprContext : public antlr4::ParserRuleContext {
   public:
    Vector_exprContext(antlr4::ParserRuleContext *parent_ctx,
                       size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *VECTOR();
    MatrixContext *matrix();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Vector_exprContext *vector_expr();

  class Function_value_exprContext : public antlr4::ParserRuleContext {
   public:
    Function_value_exprContext(antlr4::ParserRuleContext *parent_ctx,
                               size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Value_exprContext *value_expr();
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Function_value_exprContext *function_value_expr();

  class Function_callContext : public antlr4::ParserRuleContext {
   public:
    Function_callContext(antlr4::ParserRuleContext *parent_ctx,
                         size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *LP();
    antlr4::tree::TerminalNode *RP();
    std::vector<Function_value_exprContext *> function_value_expr();
    Function_value_exprContext *function_value_expr(size_t i);
    std::vector<antlr4::tree::TerminalNode *> COMMA();
    antlr4::tree::TerminalNode *COMMA(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Function_callContext *function_call();

  class Dql_statementContext : public antlr4::ParserRuleContext {
   public:
    Dql_statementContext(antlr4::ParserRuleContext *parent_ctx,
                         size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Select_statementContext *select_statement();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Dql_statementContext *dql_statement();

  class Select_statementContext : public antlr4::ParserRuleContext {
   public:
    Select_statementContext(antlr4::ParserRuleContext *parent_ctx,
                            size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *SELECT();
    Selected_elementsContext *selected_elements();
    From_clauseContext *from_clause();
    Where_clauseContext *where_clause();
    Order_by_clauseContext *order_by_clause();
    Limit_clauseContext *limit_clause();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Select_statementContext *select_statement();

  class Selected_elementsContext : public antlr4::ParserRuleContext {
   public:
    Selected_elementsContext(antlr4::ParserRuleContext *parent_ctx,
                             size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    std::vector<Selected_elementContext *> selected_element();
    Selected_elementContext *selected_element(size_t i);
    std::vector<antlr4::tree::TerminalNode *> COMMA();
    antlr4::tree::TerminalNode *COMMA(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Selected_elementsContext *selected_elements();

  class Selected_elementContext : public antlr4::ParserRuleContext {
   public:
    Selected_elementContext(antlr4::ParserRuleContext *parent_ctx,
                            size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ASTERISK();
    Field_nameContext *field_name();
    antlr4::tree::TerminalNode *AS();
    Field_aliasContext *field_alias();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Selected_elementContext *selected_element();

  class From_clauseContext : public antlr4::ParserRuleContext {
   public:
    From_clauseContext(antlr4::ParserRuleContext *parent_ctx,
                       size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *FROM();
    Tableview_nameContext *tableview_name();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  From_clauseContext *from_clause();

  class Order_by_clauseContext : public antlr4::ParserRuleContext {
   public:
    Order_by_clauseContext(antlr4::ParserRuleContext *parent_ctx,
                           size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *ORDER();
    antlr4::tree::TerminalNode *BY();
    std::vector<Order_by_elementContext *> order_by_element();
    Order_by_elementContext *order_by_element(size_t i);
    std::vector<antlr4::tree::TerminalNode *> COMMA();
    antlr4::tree::TerminalNode *COMMA(size_t i);

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Order_by_clauseContext *order_by_clause();

  class Order_by_elementContext : public antlr4::ParserRuleContext {
   public:
    Order_by_elementContext(antlr4::ParserRuleContext *parent_ctx,
                            size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Field_nameContext *field_name();
    antlr4::tree::TerminalNode *ASC();
    antlr4::tree::TerminalNode *DESC();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Order_by_elementContext *order_by_element();

  class Limit_clauseContext : public antlr4::ParserRuleContext {
   public:
    Limit_clauseContext(antlr4::ParserRuleContext *parent_ctx,
                        size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *LIMIT();
    Int_valueContext *int_value();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Limit_clauseContext *limit_clause();

  class Tableview_nameContext : public antlr4::ParserRuleContext {
   public:
    Tableview_nameContext(antlr4::ParserRuleContext *parent_ctx,
                          size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Tableview_nameContext *tableview_name();

  class Field_nameContext : public antlr4::ParserRuleContext {
   public:
    Field_nameContext(antlr4::ParserRuleContext *parent_ctx,
                      size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Field_nameContext *field_name();

  class Table_aliasContext : public antlr4::ParserRuleContext {
   public:
    Table_aliasContext(antlr4::ParserRuleContext *parent_ctx,
                       size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Table_aliasContext *table_alias();

  class Field_aliasContext : public antlr4::ParserRuleContext {
   public:
    Field_aliasContext(antlr4::ParserRuleContext *parent_ctx,
                       size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    IdentifierContext *identifier();
    antlr4::tree::TerminalNode *AS();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Field_aliasContext *field_alias();

  class NumericContext : public antlr4::ParserRuleContext {
   public:
    NumericContext(antlr4::ParserRuleContext *parent_ctx,
                   size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Int_valueContext *int_value();
    Float_valueContext *float_value();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  NumericContext *numeric();

  class Int_valueContext : public antlr4::ParserRuleContext {
   public:
    Int_valueContext(antlr4::ParserRuleContext *parent_ctx,
                     size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *INTEGER();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Int_valueContext *int_value();

  class Float_valueContext : public antlr4::ParserRuleContext {
   public:
    Float_valueContext(antlr4::ParserRuleContext *parent_ctx,
                       size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *FLOAT();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Float_valueContext *float_value();

  class Quoted_stringContext : public antlr4::ParserRuleContext {
   public:
    Quoted_stringContext(antlr4::ParserRuleContext *parent_ctx,
                         size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *SQUOTA_STRING();
    antlr4::tree::TerminalNode *DQUOTA_STRING();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Quoted_stringContext *quoted_string();

  class Bool_valueContext : public antlr4::ParserRuleContext {
   public:
    Bool_valueContext(antlr4::ParserRuleContext *parent_ctx,
                      size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *TRUE_V();
    antlr4::tree::TerminalNode *FALSE_V();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Bool_valueContext *bool_value();

  class IdentifierContext : public antlr4::ParserRuleContext {
   public:
    IdentifierContext(antlr4::ParserRuleContext *parent_ctx,
                      size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    Regular_idContext *regular_id();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  IdentifierContext *identifier();

  class Ne_opContext : public antlr4::ParserRuleContext {
   public:
    Ne_opContext(antlr4::ParserRuleContext *parent_ctx, size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *NE_OP();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Ne_opContext *ne_op();

  class Ge_opContext : public antlr4::ParserRuleContext {
   public:
    Ge_opContext(antlr4::ParserRuleContext *parent_ctx, size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *GE_OP();
    antlr4::tree::TerminalNode *G_OP();
    antlr4::tree::TerminalNode *E_OP();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Ge_opContext *ge_op();

  class Le_opContext : public antlr4::ParserRuleContext {
   public:
    Le_opContext(antlr4::ParserRuleContext *parent_ctx, size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *LE_OP();
    antlr4::tree::TerminalNode *L_OP();
    antlr4::tree::TerminalNode *E_OP();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Le_opContext *le_op();

  class Regular_idContext : public antlr4::ParserRuleContext {
   public:
    Regular_idContext(antlr4::ParserRuleContext *parent_ctx,
                      size_t invoking_state);
    virtual size_t getRuleIndex() const override;
    antlr4::tree::TerminalNode *REGULAR_ID();
    antlr4::tree::TerminalNode *OR();
    antlr4::tree::TerminalNode *AND();
    antlr4::tree::TerminalNode *NOT();
    antlr4::tree::TerminalNode *IN();
    antlr4::tree::TerminalNode *BETWEEN();
    antlr4::tree::TerminalNode *LIKE();
    antlr4::tree::TerminalNode *WHERE();
    antlr4::tree::TerminalNode *SELECT();
    antlr4::tree::TerminalNode *AS();
    antlr4::tree::TerminalNode *BY();
    antlr4::tree::TerminalNode *ORDER();
    antlr4::tree::TerminalNode *ASC();
    antlr4::tree::TerminalNode *DESC();
    antlr4::tree::TerminalNode *LIMIT();

    virtual void enterRule(antlr4::tree::ParseTreeListener *listener) override;
    virtual void exitRule(antlr4::tree::ParseTreeListener *listener) override;
  };

  Regular_idContext *regular_id();


  virtual bool sempred(antlr4::RuleContext *_localctx, size_t ruleIndex,
                       size_t predicateIndex) override;
  bool logic_exprSempred(Logic_exprContext * /*_localctx*/,
                         size_t predicateIndex);

 private:
  static std::vector<antlr4::dfa::DFA> _decisionToDFA;
  static antlr4::atn::PredictionContextCache _sharedContextCache;
  static std::vector<std::string> _ruleNames;
  static std::vector<std::string> _tokenNames;

  static std::vector<std::string> _literalNames;
  static std::vector<std::string> _symbolicNames;
  static antlr4::dfa::Vocabulary _vocabulary;
  static antlr4::atn::ATN _atn;
  static std::vector<uint16_t> _serializedATN;


  struct Initializer {
    Initializer();
  };
  static Initializer _init;
};

}  // namespace antlr4
