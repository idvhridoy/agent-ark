
// Generated from SQLParser.g4 by ANTLR 4.8

#pragma once


#include "SQLParser.h"
#include "antlr4-runtime.h"


namespace antlr4 {

/**
 * This interface defines an abstract listener for a parse tree produced by
 * SQLParser.
 */
class SQLParserListener : public antlr4::tree::ParseTreeListener {
 public:
  virtual void enterSwallow_to_semi(SQLParser::Swallow_to_semiContext *ctx) = 0;
  virtual void exitSwallow_to_semi(SQLParser::Swallow_to_semiContext *ctx) = 0;

  virtual void enterCompilation_unit(
      SQLParser::Compilation_unitContext *ctx) = 0;
  virtual void exitCompilation_unit(
      SQLParser::Compilation_unitContext *ctx) = 0;

  virtual void enterLogic_expr_unit(SQLParser::Logic_expr_unitContext *ctx) = 0;
  virtual void exitLogic_expr_unit(SQLParser::Logic_expr_unitContext *ctx) = 0;

  virtual void enterUnit_statement(SQLParser::Unit_statementContext *ctx) = 0;
  virtual void exitUnit_statement(SQLParser::Unit_statementContext *ctx) = 0;

  virtual void enterWhere_clause(SQLParser::Where_clauseContext *ctx) = 0;
  virtual void exitWhere_clause(SQLParser::Where_clauseContext *ctx) = 0;

  virtual void enterLogic_expr(SQLParser::Logic_exprContext *ctx) = 0;
  virtual void exitLogic_expr(SQLParser::Logic_exprContext *ctx) = 0;

  virtual void enterEnclosed_expr(SQLParser::Enclosed_exprContext *ctx) = 0;
  virtual void exitEnclosed_expr(SQLParser::Enclosed_exprContext *ctx) = 0;

  virtual void enterRelation_expr(SQLParser::Relation_exprContext *ctx) = 0;
  virtual void exitRelation_expr(SQLParser::Relation_exprContext *ctx) = 0;

  virtual void enterRel_oper(SQLParser::Rel_operContext *ctx) = 0;
  virtual void exitRel_oper(SQLParser::Rel_operContext *ctx) = 0;

  virtual void enterValue_expr(SQLParser::Value_exprContext *ctx) = 0;
  virtual void exitValue_expr(SQLParser::Value_exprContext *ctx) = 0;

  virtual void enterIn_value_expr_list(
      SQLParser::In_value_expr_listContext *ctx) = 0;
  virtual void exitIn_value_expr_list(
      SQLParser::In_value_expr_listContext *ctx) = 0;

  virtual void enterIn_value_expr(SQLParser::In_value_exprContext *ctx) = 0;
  virtual void exitIn_value_expr(SQLParser::In_value_exprContext *ctx) = 0;

  virtual void enterConstant(SQLParser::ConstantContext *ctx) = 0;
  virtual void exitConstant(SQLParser::ConstantContext *ctx) = 0;

  virtual void enterConstant_num_and_str(
      SQLParser::Constant_num_and_strContext *ctx) = 0;
  virtual void exitConstant_num_and_str(
      SQLParser::Constant_num_and_strContext *ctx) = 0;

  virtual void enterMatrix(SQLParser::MatrixContext *ctx) = 0;
  virtual void exitMatrix(SQLParser::MatrixContext *ctx) = 0;

  virtual void enterVector_expr(SQLParser::Vector_exprContext *ctx) = 0;
  virtual void exitVector_expr(SQLParser::Vector_exprContext *ctx) = 0;

  virtual void enterFunction_value_expr(
      SQLParser::Function_value_exprContext *ctx) = 0;
  virtual void exitFunction_value_expr(
      SQLParser::Function_value_exprContext *ctx) = 0;

  virtual void enterFunction_call(SQLParser::Function_callContext *ctx) = 0;
  virtual void exitFunction_call(SQLParser::Function_callContext *ctx) = 0;

  virtual void enterDql_statement(SQLParser::Dql_statementContext *ctx) = 0;
  virtual void exitDql_statement(SQLParser::Dql_statementContext *ctx) = 0;

  virtual void enterSelect_statement(
      SQLParser::Select_statementContext *ctx) = 0;
  virtual void exitSelect_statement(
      SQLParser::Select_statementContext *ctx) = 0;

  virtual void enterSelected_elements(
      SQLParser::Selected_elementsContext *ctx) = 0;
  virtual void exitSelected_elements(
      SQLParser::Selected_elementsContext *ctx) = 0;

  virtual void enterSelected_element(
      SQLParser::Selected_elementContext *ctx) = 0;
  virtual void exitSelected_element(
      SQLParser::Selected_elementContext *ctx) = 0;

  virtual void enterFrom_clause(SQLParser::From_clauseContext *ctx) = 0;
  virtual void exitFrom_clause(SQLParser::From_clauseContext *ctx) = 0;

  virtual void enterOrder_by_clause(SQLParser::Order_by_clauseContext *ctx) = 0;
  virtual void exitOrder_by_clause(SQLParser::Order_by_clauseContext *ctx) = 0;

  virtual void enterOrder_by_element(
      SQLParser::Order_by_elementContext *ctx) = 0;
  virtual void exitOrder_by_element(
      SQLParser::Order_by_elementContext *ctx) = 0;

  virtual void enterLimit_clause(SQLParser::Limit_clauseContext *ctx) = 0;
  virtual void exitLimit_clause(SQLParser::Limit_clauseContext *ctx) = 0;

  virtual void enterTableview_name(SQLParser::Tableview_nameContext *ctx) = 0;
  virtual void exitTableview_name(SQLParser::Tableview_nameContext *ctx) = 0;

  virtual void enterField_name(SQLParser::Field_nameContext *ctx) = 0;
  virtual void exitField_name(SQLParser::Field_nameContext *ctx) = 0;

  virtual void enterTable_alias(SQLParser::Table_aliasContext *ctx) = 0;
  virtual void exitTable_alias(SQLParser::Table_aliasContext *ctx) = 0;

  virtual void enterField_alias(SQLParser::Field_aliasContext *ctx) = 0;
  virtual void exitField_alias(SQLParser::Field_aliasContext *ctx) = 0;

  virtual void enterNumeric(SQLParser::NumericContext *ctx) = 0;
  virtual void exitNumeric(SQLParser::NumericContext *ctx) = 0;

  virtual void enterInt_value(SQLParser::Int_valueContext *ctx) = 0;
  virtual void exitInt_value(SQLParser::Int_valueContext *ctx) = 0;

  virtual void enterFloat_value(SQLParser::Float_valueContext *ctx) = 0;
  virtual void exitFloat_value(SQLParser::Float_valueContext *ctx) = 0;

  virtual void enterQuoted_string(SQLParser::Quoted_stringContext *ctx) = 0;
  virtual void exitQuoted_string(SQLParser::Quoted_stringContext *ctx) = 0;

  virtual void enterBool_value(SQLParser::Bool_valueContext *ctx) = 0;
  virtual void exitBool_value(SQLParser::Bool_valueContext *ctx) = 0;

  virtual void enterIdentifier(SQLParser::IdentifierContext *ctx) = 0;
  virtual void exitIdentifier(SQLParser::IdentifierContext *ctx) = 0;

  virtual void enterNe_op(SQLParser::Ne_opContext *ctx) = 0;
  virtual void exitNe_op(SQLParser::Ne_opContext *ctx) = 0;

  virtual void enterGe_op(SQLParser::Ge_opContext *ctx) = 0;
  virtual void exitGe_op(SQLParser::Ge_opContext *ctx) = 0;

  virtual void enterLe_op(SQLParser::Le_opContext *ctx) = 0;
  virtual void exitLe_op(SQLParser::Le_opContext *ctx) = 0;

  virtual void enterRegular_id(SQLParser::Regular_idContext *ctx) = 0;
  virtual void exitRegular_id(SQLParser::Regular_idContext *ctx) = 0;
};

}  // namespace antlr4
