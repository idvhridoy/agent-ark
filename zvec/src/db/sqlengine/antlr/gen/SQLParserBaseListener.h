
// Generated from SQLParser.g4 by ANTLR 4.8

#pragma once


#include "SQLParserListener.h"
#include "antlr4-runtime.h"


namespace antlr4 {

/**
 * This class provides an empty implementation of SQLParserListener,
 * which can be extended to create a listener which only needs to handle a
 * subset of the available methods.
 */
class SQLParserBaseListener : public SQLParserListener {
 public:
  virtual void enterSwallow_to_semi(
      SQLParser::Swallow_to_semiContext * /*ctx*/) override {}
  virtual void exitSwallow_to_semi(
      SQLParser::Swallow_to_semiContext * /*ctx*/) override {}

  virtual void enterCompilation_unit(
      SQLParser::Compilation_unitContext * /*ctx*/) override {}
  virtual void exitCompilation_unit(
      SQLParser::Compilation_unitContext * /*ctx*/) override {}

  virtual void enterLogic_expr_unit(
      SQLParser::Logic_expr_unitContext * /*ctx*/) override {}
  virtual void exitLogic_expr_unit(
      SQLParser::Logic_expr_unitContext * /*ctx*/) override {}

  virtual void enterUnit_statement(
      SQLParser::Unit_statementContext * /*ctx*/) override {}
  virtual void exitUnit_statement(
      SQLParser::Unit_statementContext * /*ctx*/) override {}

  virtual void enterWhere_clause(
      SQLParser::Where_clauseContext * /*ctx*/) override {}
  virtual void exitWhere_clause(
      SQLParser::Where_clauseContext * /*ctx*/) override {}

  virtual void enterLogic_expr(
      SQLParser::Logic_exprContext * /*ctx*/) override {}
  virtual void exitLogic_expr(SQLParser::Logic_exprContext * /*ctx*/) override {
  }

  virtual void enterEnclosed_expr(
      SQLParser::Enclosed_exprContext * /*ctx*/) override {}
  virtual void exitEnclosed_expr(
      SQLParser::Enclosed_exprContext * /*ctx*/) override {}

  virtual void enterRelation_expr(
      SQLParser::Relation_exprContext * /*ctx*/) override {}
  virtual void exitRelation_expr(
      SQLParser::Relation_exprContext * /*ctx*/) override {}

  virtual void enterRel_oper(SQLParser::Rel_operContext * /*ctx*/) override {}
  virtual void exitRel_oper(SQLParser::Rel_operContext * /*ctx*/) override {}

  virtual void enterValue_expr(
      SQLParser::Value_exprContext * /*ctx*/) override {}
  virtual void exitValue_expr(SQLParser::Value_exprContext * /*ctx*/) override {
  }

  virtual void enterIn_value_expr_list(
      SQLParser::In_value_expr_listContext * /*ctx*/) override {}
  virtual void exitIn_value_expr_list(
      SQLParser::In_value_expr_listContext * /*ctx*/) override {}

  virtual void enterIn_value_expr(
      SQLParser::In_value_exprContext * /*ctx*/) override {}
  virtual void exitIn_value_expr(
      SQLParser::In_value_exprContext * /*ctx*/) override {}

  virtual void enterConstant(SQLParser::ConstantContext * /*ctx*/) override {}
  virtual void exitConstant(SQLParser::ConstantContext * /*ctx*/) override {}

  virtual void enterConstant_num_and_str(
      SQLParser::Constant_num_and_strContext * /*ctx*/) override {}
  virtual void exitConstant_num_and_str(
      SQLParser::Constant_num_and_strContext * /*ctx*/) override {}

  virtual void enterMatrix(SQLParser::MatrixContext * /*ctx*/) override {}
  virtual void exitMatrix(SQLParser::MatrixContext * /*ctx*/) override {}

  virtual void enterVector_expr(
      SQLParser::Vector_exprContext * /*ctx*/) override {}
  virtual void exitVector_expr(
      SQLParser::Vector_exprContext * /*ctx*/) override {}

  virtual void enterFunction_value_expr(
      SQLParser::Function_value_exprContext * /*ctx*/) override {}
  virtual void exitFunction_value_expr(
      SQLParser::Function_value_exprContext * /*ctx*/) override {}

  virtual void enterFunction_call(
      SQLParser::Function_callContext * /*ctx*/) override {}
  virtual void exitFunction_call(
      SQLParser::Function_callContext * /*ctx*/) override {}

  virtual void enterDql_statement(
      SQLParser::Dql_statementContext * /*ctx*/) override {}
  virtual void exitDql_statement(
      SQLParser::Dql_statementContext * /*ctx*/) override {}

  virtual void enterSelect_statement(
      SQLParser::Select_statementContext * /*ctx*/) override {}
  virtual void exitSelect_statement(
      SQLParser::Select_statementContext * /*ctx*/) override {}

  virtual void enterSelected_elements(
      SQLParser::Selected_elementsContext * /*ctx*/) override {}
  virtual void exitSelected_elements(
      SQLParser::Selected_elementsContext * /*ctx*/) override {}

  virtual void enterSelected_element(
      SQLParser::Selected_elementContext * /*ctx*/) override {}
  virtual void exitSelected_element(
      SQLParser::Selected_elementContext * /*ctx*/) override {}

  virtual void enterFrom_clause(
      SQLParser::From_clauseContext * /*ctx*/) override {}
  virtual void exitFrom_clause(
      SQLParser::From_clauseContext * /*ctx*/) override {}

  virtual void enterOrder_by_clause(
      SQLParser::Order_by_clauseContext * /*ctx*/) override {}
  virtual void exitOrder_by_clause(
      SQLParser::Order_by_clauseContext * /*ctx*/) override {}

  virtual void enterOrder_by_element(
      SQLParser::Order_by_elementContext * /*ctx*/) override {}
  virtual void exitOrder_by_element(
      SQLParser::Order_by_elementContext * /*ctx*/) override {}

  virtual void enterLimit_clause(
      SQLParser::Limit_clauseContext * /*ctx*/) override {}
  virtual void exitLimit_clause(
      SQLParser::Limit_clauseContext * /*ctx*/) override {}

  virtual void enterTableview_name(
      SQLParser::Tableview_nameContext * /*ctx*/) override {}
  virtual void exitTableview_name(
      SQLParser::Tableview_nameContext * /*ctx*/) override {}

  virtual void enterField_name(
      SQLParser::Field_nameContext * /*ctx*/) override {}
  virtual void exitField_name(SQLParser::Field_nameContext * /*ctx*/) override {
  }

  virtual void enterTable_alias(
      SQLParser::Table_aliasContext * /*ctx*/) override {}
  virtual void exitTable_alias(
      SQLParser::Table_aliasContext * /*ctx*/) override {}

  virtual void enterField_alias(
      SQLParser::Field_aliasContext * /*ctx*/) override {}
  virtual void exitField_alias(
      SQLParser::Field_aliasContext * /*ctx*/) override {}

  virtual void enterNumeric(SQLParser::NumericContext * /*ctx*/) override {}
  virtual void exitNumeric(SQLParser::NumericContext * /*ctx*/) override {}

  virtual void enterInt_value(SQLParser::Int_valueContext * /*ctx*/) override {}
  virtual void exitInt_value(SQLParser::Int_valueContext * /*ctx*/) override {}

  virtual void enterFloat_value(
      SQLParser::Float_valueContext * /*ctx*/) override {}
  virtual void exitFloat_value(
      SQLParser::Float_valueContext * /*ctx*/) override {}

  virtual void enterQuoted_string(
      SQLParser::Quoted_stringContext * /*ctx*/) override {}
  virtual void exitQuoted_string(
      SQLParser::Quoted_stringContext * /*ctx*/) override {}

  virtual void enterBool_value(
      SQLParser::Bool_valueContext * /*ctx*/) override {}
  virtual void exitBool_value(SQLParser::Bool_valueContext * /*ctx*/) override {
  }

  virtual void enterIdentifier(
      SQLParser::IdentifierContext * /*ctx*/) override {}
  virtual void exitIdentifier(SQLParser::IdentifierContext * /*ctx*/) override {
  }

  virtual void enterNe_op(SQLParser::Ne_opContext * /*ctx*/) override {}
  virtual void exitNe_op(SQLParser::Ne_opContext * /*ctx*/) override {}

  virtual void enterGe_op(SQLParser::Ge_opContext * /*ctx*/) override {}
  virtual void exitGe_op(SQLParser::Ge_opContext * /*ctx*/) override {}

  virtual void enterLe_op(SQLParser::Le_opContext * /*ctx*/) override {}
  virtual void exitLe_op(SQLParser::Le_opContext * /*ctx*/) override {}

  virtual void enterRegular_id(
      SQLParser::Regular_idContext * /*ctx*/) override {}
  virtual void exitRegular_id(SQLParser::Regular_idContext * /*ctx*/) override {
  }


  virtual void enterEveryRule(antlr4::ParserRuleContext * /*ctx*/) override {}
  virtual void exitEveryRule(antlr4::ParserRuleContext * /*ctx*/) override {}
  virtual void visitTerminal(antlr4::tree::TerminalNode * /*node*/) override {}
  virtual void visitErrorNode(antlr4::tree::ErrorNode * /*node*/) override {}
};

}  // namespace antlr4
