
// Generated from SQLParser.g4 by ANTLR 4.8


#include "SQLParser.h"
#include "SQLParserListener.h"


using namespace antlrcpp;
using namespace antlr4;
using namespace antlr4;

SQLParser::SQLParser(TokenStream *input) : Parser(input) {
  _interpreter = new atn::ParserATNSimulator(this, _atn, _decisionToDFA,
                                             _sharedContextCache);
}

SQLParser::~SQLParser() {
  delete _interpreter;
}

std::string SQLParser::getGrammarFileName() const {
  return "SQLParser.g4";
}

const std::vector<std::string> &SQLParser::getRuleNames() const {
  return _ruleNames;
}

dfa::Vocabulary &SQLParser::getVocabulary() const {
  return _vocabulary;
}


//----------------- Swallow_to_semiContext
//------------------------------------------------------------------

SQLParser::Swallow_to_semiContext::Swallow_to_semiContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

std::vector<tree::TerminalNode *> SQLParser::Swallow_to_semiContext::SEMI() {
  return getTokens(SQLParser::SEMI);
}

tree::TerminalNode *SQLParser::Swallow_to_semiContext::SEMI(size_t i) {
  return getToken(SQLParser::SEMI, i);
}


size_t SQLParser::Swallow_to_semiContext::getRuleIndex() const {
  return SQLParser::RuleSwallow_to_semi;
}

void SQLParser::Swallow_to_semiContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterSwallow_to_semi(this);
}

void SQLParser::Swallow_to_semiContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitSwallow_to_semi(this);
}

SQLParser::Swallow_to_semiContext *SQLParser::swallow_to_semi() {
  Swallow_to_semiContext *_localctx =
      _tracker.createInstance<Swallow_to_semiContext>(_ctx, getState());
  enterRule(_localctx, 0, SQLParser::RuleSwallow_to_semi);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(81);
    _errHandler->sync(this);
    _la = _input->LA(1);
    do {
      setState(80);
      _la = _input->LA(1);
      if (_la == 0 || _la == Token::EOF || (_la == SQLParser::SEMI)) {
        _errHandler->recoverInline(this);
      } else {
        _errHandler->reportMatch(this);
        consume();
      }
      setState(83);
      _errHandler->sync(this);
      _la = _input->LA(1);
    } while (
        (((_la & ~0x3fULL) == 0) &&
         ((1ULL << _la) &
          ((1ULL << SQLParser::OR) | (1ULL << SQLParser::AND) |
           (1ULL << SQLParser::NOT) | (1ULL << SQLParser::IN) |
           (1ULL << SQLParser::CONTAIN_ALL) | (1ULL << SQLParser::CONTAIN_ANY) |
           (1ULL << SQLParser::BETWEEN) | (1ULL << SQLParser::LIKE) |
           (1ULL << SQLParser::WHERE) | (1ULL << SQLParser::SELECT) |
           (1ULL << SQLParser::FROM) | (1ULL << SQLParser::AS) |
           (1ULL << SQLParser::BY) | (1ULL << SQLParser::ORDER) |
           (1ULL << SQLParser::ASC) | (1ULL << SQLParser::DESC) |
           (1ULL << SQLParser::LIMIT) | (1ULL << SQLParser::TRUE_V) |
           (1ULL << SQLParser::FALSE_V) | (1ULL << SQLParser::IS) |
           (1ULL << SQLParser::NULL_V) | (1ULL << SQLParser::INTEGER) |
           (1ULL << SQLParser::FLOAT) | (1ULL << SQLParser::SQUOTA_STRING) |
           (1ULL << SQLParser::DQUOTA_STRING) | (1ULL << SQLParser::DOT) |
           (1ULL << SQLParser::LP) | (1ULL << SQLParser::RP) |
           (1ULL << SQLParser::LMP) | (1ULL << SQLParser::RMP) |
           (1ULL << SQLParser::ASTERISK) | (1ULL << SQLParser::PLUS_SIGN) |
           (1ULL << SQLParser::MINUS_SIGN) | (1ULL << SQLParser::COMMA) |
           (1ULL << SQLParser::SOLIDUS) | (1ULL << SQLParser::MOD) |
           (1ULL << SQLParser::AT_SIGN) | (1ULL << SQLParser::ASSIGN_OP) |
           (1ULL << SQLParser::SHARP_SIGN) | (1ULL << SQLParser::COLON) |
           (1ULL << SQLParser::LE_OP) | (1ULL << SQLParser::GE_OP) |
           (1ULL << SQLParser::NE_OP) | (1ULL << SQLParser::CARET_OP) |
           (1ULL << SQLParser::TILDE_OP) | (1ULL << SQLParser::L_OP) |
           (1ULL << SQLParser::G_OP) | (1ULL << SQLParser::E_OP) |
           (1ULL << SQLParser::CONCAT_OP) | (1ULL << SQLParser::UNDERSCORE) |
           (1ULL << SQLParser::SPACES) | (1ULL << SQLParser::VECTOR) |
           (1ULL << SQLParser::SINGLE_LINE_COMMENT) |
           (1ULL << SQLParser::MULTI_LINE_COMMENT) |
           (1ULL << SQLParser::REGULAR_ID))) != 0));

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Compilation_unitContext
//------------------------------------------------------------------

SQLParser::Compilation_unitContext::Compilation_unitContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Compilation_unitContext::EOF() {
  return getToken(SQLParser::EOF, 0);
}

std::vector<SQLParser::Unit_statementContext *>
SQLParser::Compilation_unitContext::unit_statement() {
  return getRuleContexts<SQLParser::Unit_statementContext>();
}

SQLParser::Unit_statementContext *
SQLParser::Compilation_unitContext::unit_statement(size_t i) {
  return getRuleContext<SQLParser::Unit_statementContext>(i);
}

std::vector<tree::TerminalNode *>
SQLParser::Compilation_unitContext::SOLIDUS() {
  return getTokens(SQLParser::SOLIDUS);
}

tree::TerminalNode *SQLParser::Compilation_unitContext::SOLIDUS(size_t i) {
  return getToken(SQLParser::SOLIDUS, i);
}

std::vector<tree::TerminalNode *> SQLParser::Compilation_unitContext::SEMI() {
  return getTokens(SQLParser::SEMI);
}

tree::TerminalNode *SQLParser::Compilation_unitContext::SEMI(size_t i) {
  return getToken(SQLParser::SEMI, i);
}


size_t SQLParser::Compilation_unitContext::getRuleIndex() const {
  return SQLParser::RuleCompilation_unit;
}

void SQLParser::Compilation_unitContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterCompilation_unit(this);
}

void SQLParser::Compilation_unitContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitCompilation_unit(this);
}

SQLParser::Compilation_unitContext *SQLParser::compilation_unit() {
  Compilation_unitContext *_localctx =
      _tracker.createInstance<Compilation_unitContext>(_ctx, getState());
  enterRule(_localctx, 2, SQLParser::RuleCompilation_unit);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(89);
    _errHandler->sync(this);
    _la = _input->LA(1);
    do {
      setState(85);
      unit_statement();
      setState(87);
      _errHandler->sync(this);

      _la = _input->LA(1);
      if (_la == SQLParser::SOLIDUS

          || _la == SQLParser::SEMI) {
        setState(86);
        _la = _input->LA(1);
        if (!(_la == SQLParser::SOLIDUS

              || _la == SQLParser::SEMI)) {
          _errHandler->recoverInline(this);
        } else {
          _errHandler->reportMatch(this);
          consume();
        }
      }
      setState(91);
      _errHandler->sync(this);
      _la = _input->LA(1);
    } while (_la == SQLParser::SELECT);
    setState(93);
    match(SQLParser::EOF);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Logic_expr_unitContext
//------------------------------------------------------------------

SQLParser::Logic_expr_unitContext::Logic_expr_unitContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Logic_exprContext *SQLParser::Logic_expr_unitContext::logic_expr() {
  return getRuleContext<SQLParser::Logic_exprContext>(0);
}

tree::TerminalNode *SQLParser::Logic_expr_unitContext::EOF() {
  return getToken(SQLParser::EOF, 0);
}


size_t SQLParser::Logic_expr_unitContext::getRuleIndex() const {
  return SQLParser::RuleLogic_expr_unit;
}

void SQLParser::Logic_expr_unitContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterLogic_expr_unit(this);
}

void SQLParser::Logic_expr_unitContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitLogic_expr_unit(this);
}

SQLParser::Logic_expr_unitContext *SQLParser::logic_expr_unit() {
  Logic_expr_unitContext *_localctx =
      _tracker.createInstance<Logic_expr_unitContext>(_ctx, getState());
  enterRule(_localctx, 4, SQLParser::RuleLogic_expr_unit);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(95);
    logic_expr(0);
    setState(96);
    match(SQLParser::EOF);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Unit_statementContext
//------------------------------------------------------------------

SQLParser::Unit_statementContext::Unit_statementContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Dql_statementContext *
SQLParser::Unit_statementContext::dql_statement() {
  return getRuleContext<SQLParser::Dql_statementContext>(0);
}


size_t SQLParser::Unit_statementContext::getRuleIndex() const {
  return SQLParser::RuleUnit_statement;
}

void SQLParser::Unit_statementContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterUnit_statement(this);
}

void SQLParser::Unit_statementContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitUnit_statement(this);
}

SQLParser::Unit_statementContext *SQLParser::unit_statement() {
  Unit_statementContext *_localctx =
      _tracker.createInstance<Unit_statementContext>(_ctx, getState());
  enterRule(_localctx, 6, SQLParser::RuleUnit_statement);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(98);
    dql_statement();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Where_clauseContext
//------------------------------------------------------------------

SQLParser::Where_clauseContext::Where_clauseContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Where_clauseContext::WHERE() {
  return getToken(SQLParser::WHERE, 0);
}

SQLParser::Logic_exprContext *SQLParser::Where_clauseContext::logic_expr() {
  return getRuleContext<SQLParser::Logic_exprContext>(0);
}


size_t SQLParser::Where_clauseContext::getRuleIndex() const {
  return SQLParser::RuleWhere_clause;
}

void SQLParser::Where_clauseContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterWhere_clause(this);
}

void SQLParser::Where_clauseContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitWhere_clause(this);
}

SQLParser::Where_clauseContext *SQLParser::where_clause() {
  Where_clauseContext *_localctx =
      _tracker.createInstance<Where_clauseContext>(_ctx, getState());
  enterRule(_localctx, 8, SQLParser::RuleWhere_clause);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(100);
    match(SQLParser::WHERE);
    setState(101);
    logic_expr(0);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Logic_exprContext
//------------------------------------------------------------------

SQLParser::Logic_exprContext::Logic_exprContext(ParserRuleContext *parent_ctx,
                                                size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Relation_exprContext *SQLParser::Logic_exprContext::relation_expr() {
  return getRuleContext<SQLParser::Relation_exprContext>(0);
}

SQLParser::Enclosed_exprContext *SQLParser::Logic_exprContext::enclosed_expr() {
  return getRuleContext<SQLParser::Enclosed_exprContext>(0);
}

std::vector<SQLParser::Logic_exprContext *>
SQLParser::Logic_exprContext::logic_expr() {
  return getRuleContexts<SQLParser::Logic_exprContext>();
}

SQLParser::Logic_exprContext *SQLParser::Logic_exprContext::logic_expr(
    size_t i) {
  return getRuleContext<SQLParser::Logic_exprContext>(i);
}

tree::TerminalNode *SQLParser::Logic_exprContext::AND() {
  return getToken(SQLParser::AND, 0);
}

tree::TerminalNode *SQLParser::Logic_exprContext::OR() {
  return getToken(SQLParser::OR, 0);
}


size_t SQLParser::Logic_exprContext::getRuleIndex() const {
  return SQLParser::RuleLogic_expr;
}

void SQLParser::Logic_exprContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterLogic_expr(this);
}

void SQLParser::Logic_exprContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitLogic_expr(this);
}


SQLParser::Logic_exprContext *SQLParser::logic_expr() {
  return logic_expr(0);
}

SQLParser::Logic_exprContext *SQLParser::logic_expr(int precedence) {
  ParserRuleContext *parentContext = _ctx;
  size_t parentState = getState();
  SQLParser::Logic_exprContext *_localctx =
      _tracker.createInstance<Logic_exprContext>(_ctx, parentState);
  SQLParser::Logic_exprContext *previousContext = _localctx;
  (void)previousContext;  // Silence compiler, in case the context is not used
                          // by generated code.
  size_t startState = 10;
  enterRecursionRule(_localctx, 10, SQLParser::RuleLogic_expr, precedence);


  auto onExit = finally([=] { unrollRecursionContexts(parentContext); });
  try {
    size_t alt;
    enterOuterAlt(_localctx, 1);
    setState(106);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::OR:
      case SQLParser::AND:
      case SQLParser::NOT:
      case SQLParser::IN:
      case SQLParser::BETWEEN:
      case SQLParser::LIKE:
      case SQLParser::WHERE:
      case SQLParser::SELECT:
      case SQLParser::AS:
      case SQLParser::BY:
      case SQLParser::ORDER:
      case SQLParser::ASC:
      case SQLParser::DESC:
      case SQLParser::LIMIT:
      case SQLParser::REGULAR_ID: {
        setState(104);
        relation_expr();
        break;
      }

      case SQLParser::LP: {
        setState(105);
        enclosed_expr();
        break;
      }

      default:
        throw NoViableAltException(this);
    }
    _ctx->stop = _input->LT(-1);
    setState(116);
    _errHandler->sync(this);
    alt = getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input, 5,
                                                                     _ctx);
    while (alt != 2 && alt != atn::ATN::INVALID_ALT_NUMBER) {
      if (alt == 1) {
        if (!_parseListeners.empty()) triggerExitRuleEvent();
        previousContext = _localctx;
        setState(114);
        _errHandler->sync(this);
        switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(
            _input, 4, _ctx)) {
          case 1: {
            _localctx = _tracker.createInstance<Logic_exprContext>(
                parentContext, parentState);
            pushNewRecursionContext(_localctx, startState, RuleLogic_expr);
            setState(108);

            if (!(precpred(_ctx, 3)))
              throw FailedPredicateException(this, "precpred(_ctx, 3)");
            setState(109);
            match(SQLParser::AND);
            setState(110);
            logic_expr(4);
            break;
          }

          case 2: {
            _localctx = _tracker.createInstance<Logic_exprContext>(
                parentContext, parentState);
            pushNewRecursionContext(_localctx, startState, RuleLogic_expr);
            setState(111);

            if (!(precpred(_ctx, 2)))
              throw FailedPredicateException(this, "precpred(_ctx, 2)");
            setState(112);
            match(SQLParser::OR);
            setState(113);
            logic_expr(3);
            break;
          }
        }
      }
      setState(118);
      _errHandler->sync(this);
      alt = getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(_input,
                                                                       5, _ctx);
    }
  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }
  return _localctx;
}

//----------------- Enclosed_exprContext
//------------------------------------------------------------------

SQLParser::Enclosed_exprContext::Enclosed_exprContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Enclosed_exprContext::LP() {
  return getToken(SQLParser::LP, 0);
}

SQLParser::Logic_exprContext *SQLParser::Enclosed_exprContext::logic_expr() {
  return getRuleContext<SQLParser::Logic_exprContext>(0);
}

tree::TerminalNode *SQLParser::Enclosed_exprContext::RP() {
  return getToken(SQLParser::RP, 0);
}


size_t SQLParser::Enclosed_exprContext::getRuleIndex() const {
  return SQLParser::RuleEnclosed_expr;
}

void SQLParser::Enclosed_exprContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterEnclosed_expr(this);
}

void SQLParser::Enclosed_exprContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitEnclosed_expr(this);
}

SQLParser::Enclosed_exprContext *SQLParser::enclosed_expr() {
  Enclosed_exprContext *_localctx =
      _tracker.createInstance<Enclosed_exprContext>(_ctx, getState());
  enterRule(_localctx, 12, SQLParser::RuleEnclosed_expr);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(119);
    match(SQLParser::LP);
    setState(120);
    logic_expr(0);
    setState(121);
    match(SQLParser::RP);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Relation_exprContext
//------------------------------------------------------------------

SQLParser::Relation_exprContext::Relation_exprContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::IdentifierContext *SQLParser::Relation_exprContext::identifier() {
  return getRuleContext<SQLParser::IdentifierContext>(0);
}

SQLParser::Rel_operContext *SQLParser::Relation_exprContext::rel_oper() {
  return getRuleContext<SQLParser::Rel_operContext>(0);
}

SQLParser::Value_exprContext *SQLParser::Relation_exprContext::value_expr() {
  return getRuleContext<SQLParser::Value_exprContext>(0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::LIKE() {
  return getToken(SQLParser::LIKE, 0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::IN() {
  return getToken(SQLParser::IN, 0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::LP() {
  return getToken(SQLParser::LP, 0);
}

SQLParser::In_value_expr_listContext *
SQLParser::Relation_exprContext::in_value_expr_list() {
  return getRuleContext<SQLParser::In_value_expr_listContext>(0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::RP() {
  return getToken(SQLParser::RP, 0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::NOT() {
  return getToken(SQLParser::NOT, 0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::CONTAIN_ALL() {
  return getToken(SQLParser::CONTAIN_ALL, 0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::CONTAIN_ANY() {
  return getToken(SQLParser::CONTAIN_ANY, 0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::IS() {
  return getToken(SQLParser::IS, 0);
}

tree::TerminalNode *SQLParser::Relation_exprContext::NULL_V() {
  return getToken(SQLParser::NULL_V, 0);
}

SQLParser::Function_callContext *
SQLParser::Relation_exprContext::function_call() {
  return getRuleContext<SQLParser::Function_callContext>(0);
}


size_t SQLParser::Relation_exprContext::getRuleIndex() const {
  return SQLParser::RuleRelation_expr;
}

void SQLParser::Relation_exprContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterRelation_expr(this);
}

void SQLParser::Relation_exprContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitRelation_expr(this);
}

SQLParser::Relation_exprContext *SQLParser::relation_expr() {
  Relation_exprContext *_localctx =
      _tracker.createInstance<Relation_exprContext>(_ctx, getState());
  enterRule(_localctx, 14, SQLParser::RuleRelation_expr);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(162);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(
        _input, 10, _ctx)) {
      case 1: {
        enterOuterAlt(_localctx, 1);
        setState(123);
        identifier();
        setState(124);
        rel_oper();
        setState(125);
        value_expr();
        break;
      }

      case 2: {
        enterOuterAlt(_localctx, 2);
        setState(127);
        identifier();
        setState(128);
        match(SQLParser::LIKE);
        setState(129);
        value_expr();
        break;
      }

      case 3: {
        enterOuterAlt(_localctx, 3);
        setState(131);
        identifier();
        setState(133);
        _errHandler->sync(this);

        _la = _input->LA(1);
        if (_la == SQLParser::NOT) {
          setState(132);
          match(SQLParser::NOT);
        }
        setState(135);
        match(SQLParser::IN);
        setState(136);
        match(SQLParser::LP);
        setState(137);
        in_value_expr_list();
        setState(138);
        match(SQLParser::RP);
        break;
      }

      case 4: {
        enterOuterAlt(_localctx, 4);
        setState(140);
        identifier();
        setState(142);
        _errHandler->sync(this);

        _la = _input->LA(1);
        if (_la == SQLParser::NOT) {
          setState(141);
          match(SQLParser::NOT);
        }
        setState(144);
        _la = _input->LA(1);
        if (!(_la == SQLParser::CONTAIN_ALL

              || _la == SQLParser::CONTAIN_ANY)) {
          _errHandler->recoverInline(this);
        } else {
          _errHandler->reportMatch(this);
          consume();
        }
        setState(145);
        match(SQLParser::LP);
        setState(147);
        _errHandler->sync(this);

        _la = _input->LA(1);
        if ((((_la & ~0x3fULL) == 0) &&
             ((1ULL << _la) &
              ((1ULL << SQLParser::TRUE_V) | (1ULL << SQLParser::FALSE_V) |
               (1ULL << SQLParser::INTEGER) | (1ULL << SQLParser::FLOAT) |
               (1ULL << SQLParser::SQUOTA_STRING) |
               (1ULL << SQLParser::DQUOTA_STRING))) != 0)) {
          setState(146);
          in_value_expr_list();
        }
        setState(149);
        match(SQLParser::RP);
        break;
      }

      case 5: {
        enterOuterAlt(_localctx, 5);
        setState(151);
        identifier();
        setState(152);
        match(SQLParser::IS);
        setState(154);
        _errHandler->sync(this);

        _la = _input->LA(1);
        if (_la == SQLParser::NOT) {
          setState(153);
          match(SQLParser::NOT);
        }
        setState(156);
        match(SQLParser::NULL_V);
        break;
      }

      case 6: {
        enterOuterAlt(_localctx, 6);
        setState(158);
        function_call();
        setState(159);
        rel_oper();
        setState(160);
        value_expr();
        break;
      }
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Rel_operContext
//------------------------------------------------------------------

SQLParser::Rel_operContext::Rel_operContext(ParserRuleContext *parent_ctx,
                                            size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Rel_operContext::E_OP() {
  return getToken(SQLParser::E_OP, 0);
}

SQLParser::Ne_opContext *SQLParser::Rel_operContext::ne_op() {
  return getRuleContext<SQLParser::Ne_opContext>(0);
}

tree::TerminalNode *SQLParser::Rel_operContext::L_OP() {
  return getToken(SQLParser::L_OP, 0);
}

tree::TerminalNode *SQLParser::Rel_operContext::G_OP() {
  return getToken(SQLParser::G_OP, 0);
}

SQLParser::Le_opContext *SQLParser::Rel_operContext::le_op() {
  return getRuleContext<SQLParser::Le_opContext>(0);
}

SQLParser::Ge_opContext *SQLParser::Rel_operContext::ge_op() {
  return getRuleContext<SQLParser::Ge_opContext>(0);
}


size_t SQLParser::Rel_operContext::getRuleIndex() const {
  return SQLParser::RuleRel_oper;
}

void SQLParser::Rel_operContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterRel_oper(this);
}

void SQLParser::Rel_operContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitRel_oper(this);
}

SQLParser::Rel_operContext *SQLParser::rel_oper() {
  Rel_operContext *_localctx =
      _tracker.createInstance<Rel_operContext>(_ctx, getState());
  enterRule(_localctx, 16, SQLParser::RuleRel_oper);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(170);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(
        _input, 11, _ctx)) {
      case 1: {
        enterOuterAlt(_localctx, 1);
        setState(164);
        match(SQLParser::E_OP);
        break;
      }

      case 2: {
        enterOuterAlt(_localctx, 2);
        setState(165);
        ne_op();
        break;
      }

      case 3: {
        enterOuterAlt(_localctx, 3);
        setState(166);
        match(SQLParser::L_OP);
        break;
      }

      case 4: {
        enterOuterAlt(_localctx, 4);
        setState(167);
        match(SQLParser::G_OP);
        break;
      }

      case 5: {
        enterOuterAlt(_localctx, 5);
        setState(168);
        le_op();
        break;
      }

      case 6: {
        enterOuterAlt(_localctx, 6);
        setState(169);
        ge_op();
        break;
      }
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Value_exprContext
//------------------------------------------------------------------

SQLParser::Value_exprContext::Value_exprContext(ParserRuleContext *parent_ctx,
                                                size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::ConstantContext *SQLParser::Value_exprContext::constant() {
  return getRuleContext<SQLParser::ConstantContext>(0);
}

SQLParser::Function_callContext *SQLParser::Value_exprContext::function_call() {
  return getRuleContext<SQLParser::Function_callContext>(0);
}


size_t SQLParser::Value_exprContext::getRuleIndex() const {
  return SQLParser::RuleValue_expr;
}

void SQLParser::Value_exprContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterValue_expr(this);
}

void SQLParser::Value_exprContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitValue_expr(this);
}

SQLParser::Value_exprContext *SQLParser::value_expr() {
  Value_exprContext *_localctx =
      _tracker.createInstance<Value_exprContext>(_ctx, getState());
  enterRule(_localctx, 18, SQLParser::RuleValue_expr);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(174);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::TRUE_V:
      case SQLParser::FALSE_V:
      case SQLParser::INTEGER:
      case SQLParser::FLOAT:
      case SQLParser::SQUOTA_STRING:
      case SQLParser::DQUOTA_STRING:
      case SQLParser::LMP:
      case SQLParser::VECTOR: {
        enterOuterAlt(_localctx, 1);
        setState(172);
        constant();
        break;
      }

      case SQLParser::OR:
      case SQLParser::AND:
      case SQLParser::NOT:
      case SQLParser::IN:
      case SQLParser::BETWEEN:
      case SQLParser::LIKE:
      case SQLParser::WHERE:
      case SQLParser::SELECT:
      case SQLParser::AS:
      case SQLParser::BY:
      case SQLParser::ORDER:
      case SQLParser::ASC:
      case SQLParser::DESC:
      case SQLParser::LIMIT:
      case SQLParser::REGULAR_ID: {
        enterOuterAlt(_localctx, 2);
        setState(173);
        function_call();
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- In_value_expr_listContext
//------------------------------------------------------------------

SQLParser::In_value_expr_listContext::In_value_expr_listContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

std::vector<SQLParser::In_value_exprContext *>
SQLParser::In_value_expr_listContext::in_value_expr() {
  return getRuleContexts<SQLParser::In_value_exprContext>();
}

SQLParser::In_value_exprContext *
SQLParser::In_value_expr_listContext::in_value_expr(size_t i) {
  return getRuleContext<SQLParser::In_value_exprContext>(i);
}

std::vector<tree::TerminalNode *>
SQLParser::In_value_expr_listContext::COMMA() {
  return getTokens(SQLParser::COMMA);
}

tree::TerminalNode *SQLParser::In_value_expr_listContext::COMMA(size_t i) {
  return getToken(SQLParser::COMMA, i);
}


size_t SQLParser::In_value_expr_listContext::getRuleIndex() const {
  return SQLParser::RuleIn_value_expr_list;
}

void SQLParser::In_value_expr_listContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterIn_value_expr_list(this);
}

void SQLParser::In_value_expr_listContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitIn_value_expr_list(this);
}

SQLParser::In_value_expr_listContext *SQLParser::in_value_expr_list() {
  In_value_expr_listContext *_localctx =
      _tracker.createInstance<In_value_expr_listContext>(_ctx, getState());
  enterRule(_localctx, 20, SQLParser::RuleIn_value_expr_list);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(176);
    in_value_expr();
    setState(181);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SQLParser::COMMA) {
      setState(177);
      match(SQLParser::COMMA);
      setState(178);
      in_value_expr();
      setState(183);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- In_value_exprContext
//------------------------------------------------------------------

SQLParser::In_value_exprContext::In_value_exprContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Constant_num_and_strContext *
SQLParser::In_value_exprContext::constant_num_and_str() {
  return getRuleContext<SQLParser::Constant_num_and_strContext>(0);
}

SQLParser::Bool_valueContext *SQLParser::In_value_exprContext::bool_value() {
  return getRuleContext<SQLParser::Bool_valueContext>(0);
}


size_t SQLParser::In_value_exprContext::getRuleIndex() const {
  return SQLParser::RuleIn_value_expr;
}

void SQLParser::In_value_exprContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterIn_value_expr(this);
}

void SQLParser::In_value_exprContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitIn_value_expr(this);
}

SQLParser::In_value_exprContext *SQLParser::in_value_expr() {
  In_value_exprContext *_localctx =
      _tracker.createInstance<In_value_exprContext>(_ctx, getState());
  enterRule(_localctx, 22, SQLParser::RuleIn_value_expr);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(186);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::INTEGER:
      case SQLParser::FLOAT:
      case SQLParser::SQUOTA_STRING:
      case SQLParser::DQUOTA_STRING: {
        enterOuterAlt(_localctx, 1);
        setState(184);
        constant_num_and_str();
        break;
      }

      case SQLParser::TRUE_V:
      case SQLParser::FALSE_V: {
        enterOuterAlt(_localctx, 2);
        setState(185);
        bool_value();
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- ConstantContext
//------------------------------------------------------------------

SQLParser::ConstantContext::ConstantContext(ParserRuleContext *parent_ctx,
                                            size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::NumericContext *SQLParser::ConstantContext::numeric() {
  return getRuleContext<SQLParser::NumericContext>(0);
}

SQLParser::Quoted_stringContext *SQLParser::ConstantContext::quoted_string() {
  return getRuleContext<SQLParser::Quoted_stringContext>(0);
}

SQLParser::Vector_exprContext *SQLParser::ConstantContext::vector_expr() {
  return getRuleContext<SQLParser::Vector_exprContext>(0);
}

SQLParser::Bool_valueContext *SQLParser::ConstantContext::bool_value() {
  return getRuleContext<SQLParser::Bool_valueContext>(0);
}


size_t SQLParser::ConstantContext::getRuleIndex() const {
  return SQLParser::RuleConstant;
}

void SQLParser::ConstantContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterConstant(this);
}

void SQLParser::ConstantContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitConstant(this);
}

SQLParser::ConstantContext *SQLParser::constant() {
  ConstantContext *_localctx =
      _tracker.createInstance<ConstantContext>(_ctx, getState());
  enterRule(_localctx, 24, SQLParser::RuleConstant);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(192);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::INTEGER:
      case SQLParser::FLOAT: {
        enterOuterAlt(_localctx, 1);
        setState(188);
        numeric();
        break;
      }

      case SQLParser::SQUOTA_STRING:
      case SQLParser::DQUOTA_STRING: {
        enterOuterAlt(_localctx, 2);
        setState(189);
        quoted_string();
        break;
      }

      case SQLParser::LMP:
      case SQLParser::VECTOR: {
        enterOuterAlt(_localctx, 3);
        setState(190);
        vector_expr();
        break;
      }

      case SQLParser::TRUE_V:
      case SQLParser::FALSE_V: {
        enterOuterAlt(_localctx, 4);
        setState(191);
        bool_value();
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Constant_num_and_strContext
//------------------------------------------------------------------

SQLParser::Constant_num_and_strContext::Constant_num_and_strContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::NumericContext *SQLParser::Constant_num_and_strContext::numeric() {
  return getRuleContext<SQLParser::NumericContext>(0);
}

SQLParser::Quoted_stringContext *
SQLParser::Constant_num_and_strContext::quoted_string() {
  return getRuleContext<SQLParser::Quoted_stringContext>(0);
}


size_t SQLParser::Constant_num_and_strContext::getRuleIndex() const {
  return SQLParser::RuleConstant_num_and_str;
}

void SQLParser::Constant_num_and_strContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr)
    parserListener->enterConstant_num_and_str(this);
}

void SQLParser::Constant_num_and_strContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitConstant_num_and_str(this);
}

SQLParser::Constant_num_and_strContext *SQLParser::constant_num_and_str() {
  Constant_num_and_strContext *_localctx =
      _tracker.createInstance<Constant_num_and_strContext>(_ctx, getState());
  enterRule(_localctx, 26, SQLParser::RuleConstant_num_and_str);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(196);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::INTEGER:
      case SQLParser::FLOAT: {
        enterOuterAlt(_localctx, 1);
        setState(194);
        numeric();
        break;
      }

      case SQLParser::SQUOTA_STRING:
      case SQLParser::DQUOTA_STRING: {
        enterOuterAlt(_localctx, 2);
        setState(195);
        quoted_string();
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- MatrixContext
//------------------------------------------------------------------

SQLParser::MatrixContext::MatrixContext(ParserRuleContext *parent_ctx,
                                        size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::MatrixContext::LMP() {
  return getToken(SQLParser::LMP, 0);
}

std::vector<tree::TerminalNode *> SQLParser::MatrixContext::VECTOR() {
  return getTokens(SQLParser::VECTOR);
}

tree::TerminalNode *SQLParser::MatrixContext::VECTOR(size_t i) {
  return getToken(SQLParser::VECTOR, i);
}

tree::TerminalNode *SQLParser::MatrixContext::RMP() {
  return getToken(SQLParser::RMP, 0);
}

std::vector<tree::TerminalNode *> SQLParser::MatrixContext::COMMA() {
  return getTokens(SQLParser::COMMA);
}

tree::TerminalNode *SQLParser::MatrixContext::COMMA(size_t i) {
  return getToken(SQLParser::COMMA, i);
}


size_t SQLParser::MatrixContext::getRuleIndex() const {
  return SQLParser::RuleMatrix;
}

void SQLParser::MatrixContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterMatrix(this);
}

void SQLParser::MatrixContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitMatrix(this);
}

SQLParser::MatrixContext *SQLParser::matrix() {
  MatrixContext *_localctx =
      _tracker.createInstance<MatrixContext>(_ctx, getState());
  enterRule(_localctx, 28, SQLParser::RuleMatrix);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(198);
    match(SQLParser::LMP);
    setState(199);
    match(SQLParser::VECTOR);
    setState(204);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SQLParser::COMMA) {
      setState(200);
      match(SQLParser::COMMA);
      setState(201);
      match(SQLParser::VECTOR);
      setState(206);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }
    setState(207);
    match(SQLParser::RMP);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Vector_exprContext
//------------------------------------------------------------------

SQLParser::Vector_exprContext::Vector_exprContext(ParserRuleContext *parent_ctx,
                                                  size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Vector_exprContext::VECTOR() {
  return getToken(SQLParser::VECTOR, 0);
}

SQLParser::MatrixContext *SQLParser::Vector_exprContext::matrix() {
  return getRuleContext<SQLParser::MatrixContext>(0);
}


size_t SQLParser::Vector_exprContext::getRuleIndex() const {
  return SQLParser::RuleVector_expr;
}

void SQLParser::Vector_exprContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterVector_expr(this);
}

void SQLParser::Vector_exprContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitVector_expr(this);
}

SQLParser::Vector_exprContext *SQLParser::vector_expr() {
  Vector_exprContext *_localctx =
      _tracker.createInstance<Vector_exprContext>(_ctx, getState());
  enterRule(_localctx, 30, SQLParser::RuleVector_expr);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(211);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::VECTOR: {
        enterOuterAlt(_localctx, 1);
        setState(209);
        match(SQLParser::VECTOR);
        break;
      }

      case SQLParser::LMP: {
        enterOuterAlt(_localctx, 2);
        setState(210);
        matrix();
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Function_value_exprContext
//------------------------------------------------------------------

SQLParser::Function_value_exprContext::Function_value_exprContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Value_exprContext *
SQLParser::Function_value_exprContext::value_expr() {
  return getRuleContext<SQLParser::Value_exprContext>(0);
}

SQLParser::IdentifierContext *
SQLParser::Function_value_exprContext::identifier() {
  return getRuleContext<SQLParser::IdentifierContext>(0);
}


size_t SQLParser::Function_value_exprContext::getRuleIndex() const {
  return SQLParser::RuleFunction_value_expr;
}

void SQLParser::Function_value_exprContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterFunction_value_expr(this);
}

void SQLParser::Function_value_exprContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitFunction_value_expr(this);
}

SQLParser::Function_value_exprContext *SQLParser::function_value_expr() {
  Function_value_exprContext *_localctx =
      _tracker.createInstance<Function_value_exprContext>(_ctx, getState());
  enterRule(_localctx, 32, SQLParser::RuleFunction_value_expr);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(215);
    _errHandler->sync(this);
    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(
        _input, 19, _ctx)) {
      case 1: {
        enterOuterAlt(_localctx, 1);
        setState(213);
        value_expr();
        break;
      }

      case 2: {
        enterOuterAlt(_localctx, 2);
        setState(214);
        identifier();
        break;
      }
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Function_callContext
//------------------------------------------------------------------

SQLParser::Function_callContext::Function_callContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::IdentifierContext *SQLParser::Function_callContext::identifier() {
  return getRuleContext<SQLParser::IdentifierContext>(0);
}

tree::TerminalNode *SQLParser::Function_callContext::LP() {
  return getToken(SQLParser::LP, 0);
}

tree::TerminalNode *SQLParser::Function_callContext::RP() {
  return getToken(SQLParser::RP, 0);
}

std::vector<SQLParser::Function_value_exprContext *>
SQLParser::Function_callContext::function_value_expr() {
  return getRuleContexts<SQLParser::Function_value_exprContext>();
}

SQLParser::Function_value_exprContext *
SQLParser::Function_callContext::function_value_expr(size_t i) {
  return getRuleContext<SQLParser::Function_value_exprContext>(i);
}

std::vector<tree::TerminalNode *> SQLParser::Function_callContext::COMMA() {
  return getTokens(SQLParser::COMMA);
}

tree::TerminalNode *SQLParser::Function_callContext::COMMA(size_t i) {
  return getToken(SQLParser::COMMA, i);
}


size_t SQLParser::Function_callContext::getRuleIndex() const {
  return SQLParser::RuleFunction_call;
}

void SQLParser::Function_callContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterFunction_call(this);
}

void SQLParser::Function_callContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitFunction_call(this);
}

SQLParser::Function_callContext *SQLParser::function_call() {
  Function_callContext *_localctx =
      _tracker.createInstance<Function_callContext>(_ctx, getState());
  enterRule(_localctx, 34, SQLParser::RuleFunction_call);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(217);
    identifier();
    setState(218);
    match(SQLParser::LP);
    setState(227);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if ((((_la & ~0x3fULL) == 0) &&
         ((1ULL << _la) &
          ((1ULL << SQLParser::OR) | (1ULL << SQLParser::AND) |
           (1ULL << SQLParser::NOT) | (1ULL << SQLParser::IN) |
           (1ULL << SQLParser::BETWEEN) | (1ULL << SQLParser::LIKE) |
           (1ULL << SQLParser::WHERE) | (1ULL << SQLParser::SELECT) |
           (1ULL << SQLParser::AS) | (1ULL << SQLParser::BY) |
           (1ULL << SQLParser::ORDER) | (1ULL << SQLParser::ASC) |
           (1ULL << SQLParser::DESC) | (1ULL << SQLParser::LIMIT) |
           (1ULL << SQLParser::TRUE_V) | (1ULL << SQLParser::FALSE_V) |
           (1ULL << SQLParser::INTEGER) | (1ULL << SQLParser::FLOAT) |
           (1ULL << SQLParser::SQUOTA_STRING) |
           (1ULL << SQLParser::DQUOTA_STRING) | (1ULL << SQLParser::LMP) |
           (1ULL << SQLParser::VECTOR) | (1ULL << SQLParser::REGULAR_ID))) !=
             0)) {
      setState(219);
      function_value_expr();
      setState(224);
      _errHandler->sync(this);
      _la = _input->LA(1);
      while (_la == SQLParser::COMMA) {
        setState(220);
        match(SQLParser::COMMA);
        setState(221);
        function_value_expr();
        setState(226);
        _errHandler->sync(this);
        _la = _input->LA(1);
      }
    }
    setState(229);
    match(SQLParser::RP);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Dql_statementContext
//------------------------------------------------------------------

SQLParser::Dql_statementContext::Dql_statementContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Select_statementContext *
SQLParser::Dql_statementContext::select_statement() {
  return getRuleContext<SQLParser::Select_statementContext>(0);
}


size_t SQLParser::Dql_statementContext::getRuleIndex() const {
  return SQLParser::RuleDql_statement;
}

void SQLParser::Dql_statementContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterDql_statement(this);
}

void SQLParser::Dql_statementContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitDql_statement(this);
}

SQLParser::Dql_statementContext *SQLParser::dql_statement() {
  Dql_statementContext *_localctx =
      _tracker.createInstance<Dql_statementContext>(_ctx, getState());
  enterRule(_localctx, 36, SQLParser::RuleDql_statement);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(231);
    select_statement();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Select_statementContext
//------------------------------------------------------------------

SQLParser::Select_statementContext::Select_statementContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Select_statementContext::SELECT() {
  return getToken(SQLParser::SELECT, 0);
}

SQLParser::Selected_elementsContext *
SQLParser::Select_statementContext::selected_elements() {
  return getRuleContext<SQLParser::Selected_elementsContext>(0);
}

SQLParser::From_clauseContext *
SQLParser::Select_statementContext::from_clause() {
  return getRuleContext<SQLParser::From_clauseContext>(0);
}

SQLParser::Where_clauseContext *
SQLParser::Select_statementContext::where_clause() {
  return getRuleContext<SQLParser::Where_clauseContext>(0);
}

SQLParser::Order_by_clauseContext *
SQLParser::Select_statementContext::order_by_clause() {
  return getRuleContext<SQLParser::Order_by_clauseContext>(0);
}

SQLParser::Limit_clauseContext *
SQLParser::Select_statementContext::limit_clause() {
  return getRuleContext<SQLParser::Limit_clauseContext>(0);
}


size_t SQLParser::Select_statementContext::getRuleIndex() const {
  return SQLParser::RuleSelect_statement;
}

void SQLParser::Select_statementContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterSelect_statement(this);
}

void SQLParser::Select_statementContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitSelect_statement(this);
}

SQLParser::Select_statementContext *SQLParser::select_statement() {
  Select_statementContext *_localctx =
      _tracker.createInstance<Select_statementContext>(_ctx, getState());
  enterRule(_localctx, 38, SQLParser::RuleSelect_statement);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(233);
    match(SQLParser::SELECT);
    setState(234);
    selected_elements();
    setState(235);
    from_clause();
    setState(237);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SQLParser::WHERE) {
      setState(236);
      where_clause();
    }
    setState(240);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SQLParser::ORDER) {
      setState(239);
      order_by_clause();
    }
    setState(243);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SQLParser::LIMIT) {
      setState(242);
      limit_clause();
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Selected_elementsContext
//------------------------------------------------------------------

SQLParser::Selected_elementsContext::Selected_elementsContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

std::vector<SQLParser::Selected_elementContext *>
SQLParser::Selected_elementsContext::selected_element() {
  return getRuleContexts<SQLParser::Selected_elementContext>();
}

SQLParser::Selected_elementContext *
SQLParser::Selected_elementsContext::selected_element(size_t i) {
  return getRuleContext<SQLParser::Selected_elementContext>(i);
}

std::vector<tree::TerminalNode *> SQLParser::Selected_elementsContext::COMMA() {
  return getTokens(SQLParser::COMMA);
}

tree::TerminalNode *SQLParser::Selected_elementsContext::COMMA(size_t i) {
  return getToken(SQLParser::COMMA, i);
}


size_t SQLParser::Selected_elementsContext::getRuleIndex() const {
  return SQLParser::RuleSelected_elements;
}

void SQLParser::Selected_elementsContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterSelected_elements(this);
}

void SQLParser::Selected_elementsContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitSelected_elements(this);
}

SQLParser::Selected_elementsContext *SQLParser::selected_elements() {
  Selected_elementsContext *_localctx =
      _tracker.createInstance<Selected_elementsContext>(_ctx, getState());
  enterRule(_localctx, 40, SQLParser::RuleSelected_elements);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(245);
    selected_element();
    setState(250);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SQLParser::COMMA) {
      setState(246);
      match(SQLParser::COMMA);
      setState(247);
      selected_element();
      setState(252);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Selected_elementContext
//------------------------------------------------------------------

SQLParser::Selected_elementContext::Selected_elementContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Selected_elementContext::ASTERISK() {
  return getToken(SQLParser::ASTERISK, 0);
}

SQLParser::Field_nameContext *SQLParser::Selected_elementContext::field_name() {
  return getRuleContext<SQLParser::Field_nameContext>(0);
}

tree::TerminalNode *SQLParser::Selected_elementContext::AS() {
  return getToken(SQLParser::AS, 0);
}

SQLParser::Field_aliasContext *
SQLParser::Selected_elementContext::field_alias() {
  return getRuleContext<SQLParser::Field_aliasContext>(0);
}


size_t SQLParser::Selected_elementContext::getRuleIndex() const {
  return SQLParser::RuleSelected_element;
}

void SQLParser::Selected_elementContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterSelected_element(this);
}

void SQLParser::Selected_elementContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitSelected_element(this);
}

SQLParser::Selected_elementContext *SQLParser::selected_element() {
  Selected_elementContext *_localctx =
      _tracker.createInstance<Selected_elementContext>(_ctx, getState());
  enterRule(_localctx, 42, SQLParser::RuleSelected_element);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(261);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::ASTERISK: {
        enterOuterAlt(_localctx, 1);
        setState(253);
        match(SQLParser::ASTERISK);
        break;
      }

      case SQLParser::OR:
      case SQLParser::AND:
      case SQLParser::NOT:
      case SQLParser::IN:
      case SQLParser::BETWEEN:
      case SQLParser::LIKE:
      case SQLParser::WHERE:
      case SQLParser::SELECT:
      case SQLParser::AS:
      case SQLParser::BY:
      case SQLParser::ORDER:
      case SQLParser::ASC:
      case SQLParser::DESC:
      case SQLParser::LIMIT:
      case SQLParser::REGULAR_ID: {
        enterOuterAlt(_localctx, 2);
        setState(254);
        field_name();
        setState(256);
        _errHandler->sync(this);

        switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(
            _input, 26, _ctx)) {
          case 1: {
            setState(255);
            match(SQLParser::AS);
            break;
          }
        }
        setState(259);
        _errHandler->sync(this);

        _la = _input->LA(1);
        if ((((_la & ~0x3fULL) == 0) &&
             ((1ULL << _la) &
              ((1ULL << SQLParser::OR) | (1ULL << SQLParser::AND) |
               (1ULL << SQLParser::NOT) | (1ULL << SQLParser::IN) |
               (1ULL << SQLParser::BETWEEN) | (1ULL << SQLParser::LIKE) |
               (1ULL << SQLParser::WHERE) | (1ULL << SQLParser::SELECT) |
               (1ULL << SQLParser::AS) | (1ULL << SQLParser::BY) |
               (1ULL << SQLParser::ORDER) | (1ULL << SQLParser::ASC) |
               (1ULL << SQLParser::DESC) | (1ULL << SQLParser::LIMIT) |
               (1ULL << SQLParser::REGULAR_ID))) != 0)) {
          setState(258);
          field_alias();
        }
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- From_clauseContext
//------------------------------------------------------------------

SQLParser::From_clauseContext::From_clauseContext(ParserRuleContext *parent_ctx,
                                                  size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::From_clauseContext::FROM() {
  return getToken(SQLParser::FROM, 0);
}

SQLParser::Tableview_nameContext *
SQLParser::From_clauseContext::tableview_name() {
  return getRuleContext<SQLParser::Tableview_nameContext>(0);
}


size_t SQLParser::From_clauseContext::getRuleIndex() const {
  return SQLParser::RuleFrom_clause;
}

void SQLParser::From_clauseContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterFrom_clause(this);
}

void SQLParser::From_clauseContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitFrom_clause(this);
}

SQLParser::From_clauseContext *SQLParser::from_clause() {
  From_clauseContext *_localctx =
      _tracker.createInstance<From_clauseContext>(_ctx, getState());
  enterRule(_localctx, 44, SQLParser::RuleFrom_clause);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(263);
    match(SQLParser::FROM);
    setState(264);
    tableview_name();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Order_by_clauseContext
//------------------------------------------------------------------

SQLParser::Order_by_clauseContext::Order_by_clauseContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Order_by_clauseContext::ORDER() {
  return getToken(SQLParser::ORDER, 0);
}

tree::TerminalNode *SQLParser::Order_by_clauseContext::BY() {
  return getToken(SQLParser::BY, 0);
}

std::vector<SQLParser::Order_by_elementContext *>
SQLParser::Order_by_clauseContext::order_by_element() {
  return getRuleContexts<SQLParser::Order_by_elementContext>();
}

SQLParser::Order_by_elementContext *
SQLParser::Order_by_clauseContext::order_by_element(size_t i) {
  return getRuleContext<SQLParser::Order_by_elementContext>(i);
}

std::vector<tree::TerminalNode *> SQLParser::Order_by_clauseContext::COMMA() {
  return getTokens(SQLParser::COMMA);
}

tree::TerminalNode *SQLParser::Order_by_clauseContext::COMMA(size_t i) {
  return getToken(SQLParser::COMMA, i);
}


size_t SQLParser::Order_by_clauseContext::getRuleIndex() const {
  return SQLParser::RuleOrder_by_clause;
}

void SQLParser::Order_by_clauseContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterOrder_by_clause(this);
}

void SQLParser::Order_by_clauseContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitOrder_by_clause(this);
}

SQLParser::Order_by_clauseContext *SQLParser::order_by_clause() {
  Order_by_clauseContext *_localctx =
      _tracker.createInstance<Order_by_clauseContext>(_ctx, getState());
  enterRule(_localctx, 46, SQLParser::RuleOrder_by_clause);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(266);
    match(SQLParser::ORDER);
    setState(267);
    match(SQLParser::BY);
    setState(268);
    order_by_element();
    setState(273);
    _errHandler->sync(this);
    _la = _input->LA(1);
    while (_la == SQLParser::COMMA) {
      setState(269);
      match(SQLParser::COMMA);
      setState(270);
      order_by_element();
      setState(275);
      _errHandler->sync(this);
      _la = _input->LA(1);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Order_by_elementContext
//------------------------------------------------------------------

SQLParser::Order_by_elementContext::Order_by_elementContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Field_nameContext *SQLParser::Order_by_elementContext::field_name() {
  return getRuleContext<SQLParser::Field_nameContext>(0);
}

tree::TerminalNode *SQLParser::Order_by_elementContext::ASC() {
  return getToken(SQLParser::ASC, 0);
}

tree::TerminalNode *SQLParser::Order_by_elementContext::DESC() {
  return getToken(SQLParser::DESC, 0);
}


size_t SQLParser::Order_by_elementContext::getRuleIndex() const {
  return SQLParser::RuleOrder_by_element;
}

void SQLParser::Order_by_elementContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterOrder_by_element(this);
}

void SQLParser::Order_by_elementContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitOrder_by_element(this);
}

SQLParser::Order_by_elementContext *SQLParser::order_by_element() {
  Order_by_elementContext *_localctx =
      _tracker.createInstance<Order_by_elementContext>(_ctx, getState());
  enterRule(_localctx, 48, SQLParser::RuleOrder_by_element);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(276);
    field_name();
    setState(278);
    _errHandler->sync(this);

    _la = _input->LA(1);
    if (_la == SQLParser::ASC

        || _la == SQLParser::DESC) {
      setState(277);
      _la = _input->LA(1);
      if (!(_la == SQLParser::ASC

            || _la == SQLParser::DESC)) {
        _errHandler->recoverInline(this);
      } else {
        _errHandler->reportMatch(this);
        consume();
      }
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Limit_clauseContext
//------------------------------------------------------------------

SQLParser::Limit_clauseContext::Limit_clauseContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Limit_clauseContext::LIMIT() {
  return getToken(SQLParser::LIMIT, 0);
}

SQLParser::Int_valueContext *SQLParser::Limit_clauseContext::int_value() {
  return getRuleContext<SQLParser::Int_valueContext>(0);
}


size_t SQLParser::Limit_clauseContext::getRuleIndex() const {
  return SQLParser::RuleLimit_clause;
}

void SQLParser::Limit_clauseContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterLimit_clause(this);
}

void SQLParser::Limit_clauseContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitLimit_clause(this);
}

SQLParser::Limit_clauseContext *SQLParser::limit_clause() {
  Limit_clauseContext *_localctx =
      _tracker.createInstance<Limit_clauseContext>(_ctx, getState());
  enterRule(_localctx, 50, SQLParser::RuleLimit_clause);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(280);
    match(SQLParser::LIMIT);
    setState(281);
    int_value();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Tableview_nameContext
//------------------------------------------------------------------

SQLParser::Tableview_nameContext::Tableview_nameContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::IdentifierContext *SQLParser::Tableview_nameContext::identifier() {
  return getRuleContext<SQLParser::IdentifierContext>(0);
}


size_t SQLParser::Tableview_nameContext::getRuleIndex() const {
  return SQLParser::RuleTableview_name;
}

void SQLParser::Tableview_nameContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterTableview_name(this);
}

void SQLParser::Tableview_nameContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitTableview_name(this);
}

SQLParser::Tableview_nameContext *SQLParser::tableview_name() {
  Tableview_nameContext *_localctx =
      _tracker.createInstance<Tableview_nameContext>(_ctx, getState());
  enterRule(_localctx, 52, SQLParser::RuleTableview_name);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(283);
    identifier();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Field_nameContext
//------------------------------------------------------------------

SQLParser::Field_nameContext::Field_nameContext(ParserRuleContext *parent_ctx,
                                                size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::IdentifierContext *SQLParser::Field_nameContext::identifier() {
  return getRuleContext<SQLParser::IdentifierContext>(0);
}


size_t SQLParser::Field_nameContext::getRuleIndex() const {
  return SQLParser::RuleField_name;
}

void SQLParser::Field_nameContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterField_name(this);
}

void SQLParser::Field_nameContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitField_name(this);
}

SQLParser::Field_nameContext *SQLParser::field_name() {
  Field_nameContext *_localctx =
      _tracker.createInstance<Field_nameContext>(_ctx, getState());
  enterRule(_localctx, 54, SQLParser::RuleField_name);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(285);
    identifier();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Table_aliasContext
//------------------------------------------------------------------

SQLParser::Table_aliasContext::Table_aliasContext(ParserRuleContext *parent_ctx,
                                                  size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::IdentifierContext *SQLParser::Table_aliasContext::identifier() {
  return getRuleContext<SQLParser::IdentifierContext>(0);
}


size_t SQLParser::Table_aliasContext::getRuleIndex() const {
  return SQLParser::RuleTable_alias;
}

void SQLParser::Table_aliasContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterTable_alias(this);
}

void SQLParser::Table_aliasContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitTable_alias(this);
}

SQLParser::Table_aliasContext *SQLParser::table_alias() {
  Table_aliasContext *_localctx =
      _tracker.createInstance<Table_aliasContext>(_ctx, getState());
  enterRule(_localctx, 56, SQLParser::RuleTable_alias);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(287);
    identifier();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Field_aliasContext
//------------------------------------------------------------------

SQLParser::Field_aliasContext::Field_aliasContext(ParserRuleContext *parent_ctx,
                                                  size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::IdentifierContext *SQLParser::Field_aliasContext::identifier() {
  return getRuleContext<SQLParser::IdentifierContext>(0);
}

tree::TerminalNode *SQLParser::Field_aliasContext::AS() {
  return getToken(SQLParser::AS, 0);
}


size_t SQLParser::Field_aliasContext::getRuleIndex() const {
  return SQLParser::RuleField_alias;
}

void SQLParser::Field_aliasContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterField_alias(this);
}

void SQLParser::Field_aliasContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitField_alias(this);
}

SQLParser::Field_aliasContext *SQLParser::field_alias() {
  Field_aliasContext *_localctx =
      _tracker.createInstance<Field_aliasContext>(_ctx, getState());
  enterRule(_localctx, 58, SQLParser::RuleField_alias);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(290);
    _errHandler->sync(this);

    switch (getInterpreter<atn::ParserATNSimulator>()->adaptivePredict(
        _input, 31, _ctx)) {
      case 1: {
        setState(289);
        match(SQLParser::AS);
        break;
      }
    }
    setState(292);
    identifier();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- NumericContext
//------------------------------------------------------------------

SQLParser::NumericContext::NumericContext(ParserRuleContext *parent_ctx,
                                          size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Int_valueContext *SQLParser::NumericContext::int_value() {
  return getRuleContext<SQLParser::Int_valueContext>(0);
}

SQLParser::Float_valueContext *SQLParser::NumericContext::float_value() {
  return getRuleContext<SQLParser::Float_valueContext>(0);
}


size_t SQLParser::NumericContext::getRuleIndex() const {
  return SQLParser::RuleNumeric;
}

void SQLParser::NumericContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterNumeric(this);
}

void SQLParser::NumericContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitNumeric(this);
}

SQLParser::NumericContext *SQLParser::numeric() {
  NumericContext *_localctx =
      _tracker.createInstance<NumericContext>(_ctx, getState());
  enterRule(_localctx, 60, SQLParser::RuleNumeric);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(296);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::INTEGER: {
        enterOuterAlt(_localctx, 1);
        setState(294);
        int_value();
        break;
      }

      case SQLParser::FLOAT: {
        enterOuterAlt(_localctx, 2);
        setState(295);
        float_value();
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Int_valueContext
//------------------------------------------------------------------

SQLParser::Int_valueContext::Int_valueContext(ParserRuleContext *parent_ctx,
                                              size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Int_valueContext::INTEGER() {
  return getToken(SQLParser::INTEGER, 0);
}


size_t SQLParser::Int_valueContext::getRuleIndex() const {
  return SQLParser::RuleInt_value;
}

void SQLParser::Int_valueContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterInt_value(this);
}

void SQLParser::Int_valueContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitInt_value(this);
}

SQLParser::Int_valueContext *SQLParser::int_value() {
  Int_valueContext *_localctx =
      _tracker.createInstance<Int_valueContext>(_ctx, getState());
  enterRule(_localctx, 62, SQLParser::RuleInt_value);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(298);
    match(SQLParser::INTEGER);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Float_valueContext
//------------------------------------------------------------------

SQLParser::Float_valueContext::Float_valueContext(ParserRuleContext *parent_ctx,
                                                  size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Float_valueContext::FLOAT() {
  return getToken(SQLParser::FLOAT, 0);
}


size_t SQLParser::Float_valueContext::getRuleIndex() const {
  return SQLParser::RuleFloat_value;
}

void SQLParser::Float_valueContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterFloat_value(this);
}

void SQLParser::Float_valueContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitFloat_value(this);
}

SQLParser::Float_valueContext *SQLParser::float_value() {
  Float_valueContext *_localctx =
      _tracker.createInstance<Float_valueContext>(_ctx, getState());
  enterRule(_localctx, 64, SQLParser::RuleFloat_value);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(300);
    match(SQLParser::FLOAT);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Quoted_stringContext
//------------------------------------------------------------------

SQLParser::Quoted_stringContext::Quoted_stringContext(
    ParserRuleContext *parent_ctx, size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Quoted_stringContext::SQUOTA_STRING() {
  return getToken(SQLParser::SQUOTA_STRING, 0);
}

tree::TerminalNode *SQLParser::Quoted_stringContext::DQUOTA_STRING() {
  return getToken(SQLParser::DQUOTA_STRING, 0);
}


size_t SQLParser::Quoted_stringContext::getRuleIndex() const {
  return SQLParser::RuleQuoted_string;
}

void SQLParser::Quoted_stringContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterQuoted_string(this);
}

void SQLParser::Quoted_stringContext::exitRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitQuoted_string(this);
}

SQLParser::Quoted_stringContext *SQLParser::quoted_string() {
  Quoted_stringContext *_localctx =
      _tracker.createInstance<Quoted_stringContext>(_ctx, getState());
  enterRule(_localctx, 66, SQLParser::RuleQuoted_string);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(302);
    _la = _input->LA(1);
    if (!(_la == SQLParser::SQUOTA_STRING

          || _la == SQLParser::DQUOTA_STRING)) {
      _errHandler->recoverInline(this);
    } else {
      _errHandler->reportMatch(this);
      consume();
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Bool_valueContext
//------------------------------------------------------------------

SQLParser::Bool_valueContext::Bool_valueContext(ParserRuleContext *parent_ctx,
                                                size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Bool_valueContext::TRUE_V() {
  return getToken(SQLParser::TRUE_V, 0);
}

tree::TerminalNode *SQLParser::Bool_valueContext::FALSE_V() {
  return getToken(SQLParser::FALSE_V, 0);
}


size_t SQLParser::Bool_valueContext::getRuleIndex() const {
  return SQLParser::RuleBool_value;
}

void SQLParser::Bool_valueContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterBool_value(this);
}

void SQLParser::Bool_valueContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitBool_value(this);
}

SQLParser::Bool_valueContext *SQLParser::bool_value() {
  Bool_valueContext *_localctx =
      _tracker.createInstance<Bool_valueContext>(_ctx, getState());
  enterRule(_localctx, 68, SQLParser::RuleBool_value);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(304);
    _la = _input->LA(1);
    if (!(_la == SQLParser::TRUE_V

          || _la == SQLParser::FALSE_V)) {
      _errHandler->recoverInline(this);
    } else {
      _errHandler->reportMatch(this);
      consume();
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- IdentifierContext
//------------------------------------------------------------------

SQLParser::IdentifierContext::IdentifierContext(ParserRuleContext *parent_ctx,
                                                size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

SQLParser::Regular_idContext *SQLParser::IdentifierContext::regular_id() {
  return getRuleContext<SQLParser::Regular_idContext>(0);
}


size_t SQLParser::IdentifierContext::getRuleIndex() const {
  return SQLParser::RuleIdentifier;
}

void SQLParser::IdentifierContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterIdentifier(this);
}

void SQLParser::IdentifierContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitIdentifier(this);
}

SQLParser::IdentifierContext *SQLParser::identifier() {
  IdentifierContext *_localctx =
      _tracker.createInstance<IdentifierContext>(_ctx, getState());
  enterRule(_localctx, 70, SQLParser::RuleIdentifier);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(306);
    regular_id();

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Ne_opContext
//------------------------------------------------------------------

SQLParser::Ne_opContext::Ne_opContext(ParserRuleContext *parent_ctx,
                                      size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Ne_opContext::NE_OP() {
  return getToken(SQLParser::NE_OP, 0);
}


size_t SQLParser::Ne_opContext::getRuleIndex() const {
  return SQLParser::RuleNe_op;
}

void SQLParser::Ne_opContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterNe_op(this);
}

void SQLParser::Ne_opContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitNe_op(this);
}

SQLParser::Ne_opContext *SQLParser::ne_op() {
  Ne_opContext *_localctx =
      _tracker.createInstance<Ne_opContext>(_ctx, getState());
  enterRule(_localctx, 72, SQLParser::RuleNe_op);

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(308);
    match(SQLParser::NE_OP);

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Ge_opContext
//------------------------------------------------------------------

SQLParser::Ge_opContext::Ge_opContext(ParserRuleContext *parent_ctx,
                                      size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Ge_opContext::GE_OP() {
  return getToken(SQLParser::GE_OP, 0);
}

tree::TerminalNode *SQLParser::Ge_opContext::G_OP() {
  return getToken(SQLParser::G_OP, 0);
}

tree::TerminalNode *SQLParser::Ge_opContext::E_OP() {
  return getToken(SQLParser::E_OP, 0);
}


size_t SQLParser::Ge_opContext::getRuleIndex() const {
  return SQLParser::RuleGe_op;
}

void SQLParser::Ge_opContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterGe_op(this);
}

void SQLParser::Ge_opContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitGe_op(this);
}

SQLParser::Ge_opContext *SQLParser::ge_op() {
  Ge_opContext *_localctx =
      _tracker.createInstance<Ge_opContext>(_ctx, getState());
  enterRule(_localctx, 74, SQLParser::RuleGe_op);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(313);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::GE_OP: {
        enterOuterAlt(_localctx, 1);
        setState(310);
        match(SQLParser::GE_OP);
        break;
      }

      case SQLParser::G_OP: {
        enterOuterAlt(_localctx, 2);
        setState(311);
        match(SQLParser::G_OP);
        setState(312);
        match(SQLParser::E_OP);
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Le_opContext
//------------------------------------------------------------------

SQLParser::Le_opContext::Le_opContext(ParserRuleContext *parent_ctx,
                                      size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Le_opContext::LE_OP() {
  return getToken(SQLParser::LE_OP, 0);
}

tree::TerminalNode *SQLParser::Le_opContext::L_OP() {
  return getToken(SQLParser::L_OP, 0);
}

tree::TerminalNode *SQLParser::Le_opContext::E_OP() {
  return getToken(SQLParser::E_OP, 0);
}


size_t SQLParser::Le_opContext::getRuleIndex() const {
  return SQLParser::RuleLe_op;
}

void SQLParser::Le_opContext::enterRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterLe_op(this);
}

void SQLParser::Le_opContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitLe_op(this);
}

SQLParser::Le_opContext *SQLParser::le_op() {
  Le_opContext *_localctx =
      _tracker.createInstance<Le_opContext>(_ctx, getState());
  enterRule(_localctx, 76, SQLParser::RuleLe_op);

  auto onExit = finally([=] { exitRule(); });
  try {
    setState(318);
    _errHandler->sync(this);
    switch (_input->LA(1)) {
      case SQLParser::LE_OP: {
        enterOuterAlt(_localctx, 1);
        setState(315);
        match(SQLParser::LE_OP);
        break;
      }

      case SQLParser::L_OP: {
        enterOuterAlt(_localctx, 2);
        setState(316);
        match(SQLParser::L_OP);
        setState(317);
        match(SQLParser::E_OP);
        break;
      }

      default:
        throw NoViableAltException(this);
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

//----------------- Regular_idContext
//------------------------------------------------------------------

SQLParser::Regular_idContext::Regular_idContext(ParserRuleContext *parent_ctx,
                                                size_t invoking_state)
    : ParserRuleContext(parent_ctx, invoking_state) {}

tree::TerminalNode *SQLParser::Regular_idContext::REGULAR_ID() {
  return getToken(SQLParser::REGULAR_ID, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::OR() {
  return getToken(SQLParser::OR, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::AND() {
  return getToken(SQLParser::AND, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::NOT() {
  return getToken(SQLParser::NOT, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::IN() {
  return getToken(SQLParser::IN, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::BETWEEN() {
  return getToken(SQLParser::BETWEEN, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::LIKE() {
  return getToken(SQLParser::LIKE, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::WHERE() {
  return getToken(SQLParser::WHERE, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::SELECT() {
  return getToken(SQLParser::SELECT, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::AS() {
  return getToken(SQLParser::AS, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::BY() {
  return getToken(SQLParser::BY, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::ORDER() {
  return getToken(SQLParser::ORDER, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::ASC() {
  return getToken(SQLParser::ASC, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::DESC() {
  return getToken(SQLParser::DESC, 0);
}

tree::TerminalNode *SQLParser::Regular_idContext::LIMIT() {
  return getToken(SQLParser::LIMIT, 0);
}


size_t SQLParser::Regular_idContext::getRuleIndex() const {
  return SQLParser::RuleRegular_id;
}

void SQLParser::Regular_idContext::enterRule(
    tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->enterRegular_id(this);
}

void SQLParser::Regular_idContext::exitRule(tree::ParseTreeListener *listener) {
  auto parserListener = dynamic_cast<SQLParserListener *>(listener);
  if (parserListener != nullptr) parserListener->exitRegular_id(this);
}

SQLParser::Regular_idContext *SQLParser::regular_id() {
  Regular_idContext *_localctx =
      _tracker.createInstance<Regular_idContext>(_ctx, getState());
  enterRule(_localctx, 78, SQLParser::RuleRegular_id);
  size_t _la = 0;

  auto onExit = finally([=] { exitRule(); });
  try {
    enterOuterAlt(_localctx, 1);
    setState(320);
    _la = _input->LA(1);
    if (!((((_la & ~0x3fULL) == 0) &&
           ((1ULL << _la) &
            ((1ULL << SQLParser::OR) | (1ULL << SQLParser::AND) |
             (1ULL << SQLParser::NOT) | (1ULL << SQLParser::IN) |
             (1ULL << SQLParser::BETWEEN) | (1ULL << SQLParser::LIKE) |
             (1ULL << SQLParser::WHERE) | (1ULL << SQLParser::SELECT) |
             (1ULL << SQLParser::AS) | (1ULL << SQLParser::BY) |
             (1ULL << SQLParser::ORDER) | (1ULL << SQLParser::ASC) |
             (1ULL << SQLParser::DESC) | (1ULL << SQLParser::LIMIT) |
             (1ULL << SQLParser::REGULAR_ID))) != 0))) {
      _errHandler->recoverInline(this);
    } else {
      _errHandler->reportMatch(this);
      consume();
    }

  } catch (RecognitionException &e) {
    _errHandler->reportError(this, e);
    _localctx->exception = std::current_exception();
    _errHandler->recover(this, _localctx->exception);
  }

  return _localctx;
}

bool SQLParser::sempred(RuleContext *context, size_t ruleIndex,
                        size_t predicateIndex) {
  switch (ruleIndex) {
    case 5:
      return logic_exprSempred(dynamic_cast<Logic_exprContext *>(context),
                               predicateIndex);

    default:
      break;
  }
  return true;
}

bool SQLParser::logic_exprSempred(Logic_exprContext * /*_localctx*/,
                                  size_t predicateIndex) {
  switch (predicateIndex) {
    case 0:
      return precpred(_ctx, 3);
    case 1:
      return precpred(_ctx, 2);

    default:
      break;
  }
  return true;
}

// Static vars and initialization.
std::vector<dfa::DFA> SQLParser::_decisionToDFA;
atn::PredictionContextCache SQLParser::_sharedContextCache;

// We own the ATN which in turn owns the ATN states.
atn::ATN SQLParser::_atn;
std::vector<uint16_t> SQLParser::_serializedATN;

std::vector<std::string> SQLParser::_ruleNames = {"swallow_to_semi",
                                                  "compilation_unit",
                                                  "logic_expr_unit",
                                                  "unit_statement",
                                                  "where_clause",
                                                  "logic_expr",
                                                  "enclosed_expr",
                                                  "relation_expr",
                                                  "rel_oper",
                                                  "value_expr",
                                                  "in_value_expr_list",
                                                  "in_value_expr",
                                                  "constant",
                                                  "constant_num_and_str",
                                                  "matrix",
                                                  "vector_expr",
                                                  "function_value_expr",
                                                  "function_call",
                                                  "dql_statement",
                                                  "select_statement",
                                                  "selected_elements",
                                                  "selected_element",
                                                  "from_clause",
                                                  "order_by_clause",
                                                  "order_by_element",
                                                  "limit_clause",
                                                  "tableview_name",
                                                  "field_name",
                                                  "table_alias",
                                                  "field_alias",
                                                  "numeric",
                                                  "int_value",
                                                  "float_value",
                                                  "quoted_string",
                                                  "bool_value",
                                                  "identifier",
                                                  "ne_op",
                                                  "ge_op",
                                                  "le_op",
                                                  "regular_id"};

std::vector<std::string> SQLParser::_literalNames = {"",
                                                     "'OR'",
                                                     "'AND'",
                                                     "'NOT'",
                                                     "'IN'",
                                                     "'CONTAIN_ALL'",
                                                     "'CONTAIN_ANY'",
                                                     "'BETWEEN'",
                                                     "'LIKE'",
                                                     "'WHERE'",
                                                     "'SELECT'",
                                                     "'FROM'",
                                                     "'AS'",
                                                     "'BY'",
                                                     "'ORDER'",
                                                     "'ASC'",
                                                     "'DESC'",
                                                     "'LIMIT'",
                                                     "'TRUE'",
                                                     "'FALSE'",
                                                     "'IS'",
                                                     "'NULL'",
                                                     "",
                                                     "",
                                                     "",
                                                     "",
                                                     "'.'",
                                                     "'('",
                                                     "')'",
                                                     "'['",
                                                     "']'",
                                                     "'*'",
                                                     "'+'",
                                                     "'-'",
                                                     "','",
                                                     "'/'",
                                                     "'%'",
                                                     "'@'",
                                                     "':='",
                                                     "'#'",
                                                     "':'",
                                                     "';'",
                                                     "'<='",
                                                     "'>='",
                                                     "'!='",
                                                     "'^'",
                                                     "'~'",
                                                     "'<'",
                                                     "'>'",
                                                     "'='",
                                                     "'||'",
                                                     "'_'"};

std::vector<std::string> SQLParser::_symbolicNames = {"",
                                                      "OR",
                                                      "AND",
                                                      "NOT",
                                                      "IN",
                                                      "CONTAIN_ALL",
                                                      "CONTAIN_ANY",
                                                      "BETWEEN",
                                                      "LIKE",
                                                      "WHERE",
                                                      "SELECT",
                                                      "FROM",
                                                      "AS",
                                                      "BY",
                                                      "ORDER",
                                                      "ASC",
                                                      "DESC",
                                                      "LIMIT",
                                                      "TRUE_V",
                                                      "FALSE_V",
                                                      "IS",
                                                      "NULL_V",
                                                      "INTEGER",
                                                      "FLOAT",
                                                      "SQUOTA_STRING",
                                                      "DQUOTA_STRING",
                                                      "DOT",
                                                      "LP",
                                                      "RP",
                                                      "LMP",
                                                      "RMP",
                                                      "ASTERISK",
                                                      "PLUS_SIGN",
                                                      "MINUS_SIGN",
                                                      "COMMA",
                                                      "SOLIDUS",
                                                      "MOD",
                                                      "AT_SIGN",
                                                      "ASSIGN_OP",
                                                      "SHARP_SIGN",
                                                      "COLON",
                                                      "SEMI",
                                                      "LE_OP",
                                                      "GE_OP",
                                                      "NE_OP",
                                                      "CARET_OP",
                                                      "TILDE_OP",
                                                      "L_OP",
                                                      "G_OP",
                                                      "E_OP",
                                                      "CONCAT_OP",
                                                      "UNDERSCORE",
                                                      "SPACES",
                                                      "VECTOR",
                                                      "SINGLE_LINE_COMMENT",
                                                      "MULTI_LINE_COMMENT",
                                                      "REGULAR_ID"};

dfa::Vocabulary SQLParser::_vocabulary(_literalNames, _symbolicNames);

std::vector<std::string> SQLParser::_tokenNames;

SQLParser::Initializer::Initializer() {
  for (size_t i = 0; i < _symbolicNames.size(); ++i) {
    std::string name = _vocabulary.getLiteralName(i);
    if (name.empty()) {
      name = _vocabulary.getSymbolicName(i);
    }

    if (name.empty()) {
      _tokenNames.push_back("<INVALID>");
    } else {
      _tokenNames.push_back(name);
    }
  }

  _serializedATN = {
      0x3,   0x608b, 0xa72a, 0x8133, 0xb9ed, 0x417c, 0x3be7, 0x7786, 0x5964,
      0x3,   0x3a,   0x145,  0x4,    0x2,    0x9,    0x2,    0x4,    0x3,
      0x9,   0x3,    0x4,    0x4,    0x9,    0x4,    0x4,    0x5,    0x9,
      0x5,   0x4,    0x6,    0x9,    0x6,    0x4,    0x7,    0x9,    0x7,
      0x4,   0x8,    0x9,    0x8,    0x4,    0x9,    0x9,    0x9,    0x4,
      0xa,   0x9,    0xa,    0x4,    0xb,    0x9,    0xb,    0x4,    0xc,
      0x9,   0xc,    0x4,    0xd,    0x9,    0xd,    0x4,    0xe,    0x9,
      0xe,   0x4,    0xf,    0x9,    0xf,    0x4,    0x10,   0x9,    0x10,
      0x4,   0x11,   0x9,    0x11,   0x4,    0x12,   0x9,    0x12,   0x4,
      0x13,  0x9,    0x13,   0x4,    0x14,   0x9,    0x14,   0x4,    0x15,
      0x9,   0x15,   0x4,    0x16,   0x9,    0x16,   0x4,    0x17,   0x9,
      0x17,  0x4,    0x18,   0x9,    0x18,   0x4,    0x19,   0x9,    0x19,
      0x4,   0x1a,   0x9,    0x1a,   0x4,    0x1b,   0x9,    0x1b,   0x4,
      0x1c,  0x9,    0x1c,   0x4,    0x1d,   0x9,    0x1d,   0x4,    0x1e,
      0x9,   0x1e,   0x4,    0x1f,   0x9,    0x1f,   0x4,    0x20,   0x9,
      0x20,  0x4,    0x21,   0x9,    0x21,   0x4,    0x22,   0x9,    0x22,
      0x4,   0x23,   0x9,    0x23,   0x4,    0x24,   0x9,    0x24,   0x4,
      0x25,  0x9,    0x25,   0x4,    0x26,   0x9,    0x26,   0x4,    0x27,
      0x9,   0x27,   0x4,    0x28,   0x9,    0x28,   0x4,    0x29,   0x9,
      0x29,  0x3,    0x2,    0x6,    0x2,    0x54,   0xa,    0x2,    0xd,
      0x2,   0xe,    0x2,    0x55,   0x3,    0x3,    0x3,    0x3,    0x5,
      0x3,   0x5a,   0xa,    0x3,    0x6,    0x3,    0x5c,   0xa,    0x3,
      0xd,   0x3,    0xe,    0x3,    0x5d,   0x3,    0x3,    0x3,    0x3,
      0x3,   0x4,    0x3,    0x4,    0x3,    0x4,    0x3,    0x5,    0x3,
      0x5,   0x3,    0x6,    0x3,    0x6,    0x3,    0x6,    0x3,    0x7,
      0x3,   0x7,    0x3,    0x7,    0x5,    0x7,    0x6d,   0xa,    0x7,
      0x3,   0x7,    0x3,    0x7,    0x3,    0x7,    0x3,    0x7,    0x3,
      0x7,   0x3,    0x7,    0x7,    0x7,    0x75,   0xa,    0x7,    0xc,
      0x7,   0xe,    0x7,    0x78,   0xb,    0x7,    0x3,    0x8,    0x3,
      0x8,   0x3,    0x8,    0x3,    0x8,    0x3,    0x9,    0x3,    0x9,
      0x3,   0x9,    0x3,    0x9,    0x3,    0x9,    0x3,    0x9,    0x3,
      0x9,   0x3,    0x9,    0x3,    0x9,    0x3,    0x9,    0x5,    0x9,
      0x88,  0xa,    0x9,    0x3,    0x9,    0x3,    0x9,    0x3,    0x9,
      0x3,   0x9,    0x3,    0x9,    0x3,    0x9,    0x3,    0x9,    0x5,
      0x9,   0x91,   0xa,    0x9,    0x3,    0x9,    0x3,    0x9,    0x3,
      0x9,   0x5,    0x9,    0x96,   0xa,    0x9,    0x3,    0x9,    0x3,
      0x9,   0x3,    0x9,    0x3,    0x9,    0x3,    0x9,    0x5,    0x9,
      0x9d,  0xa,    0x9,    0x3,    0x9,    0x3,    0x9,    0x3,    0x9,
      0x3,   0x9,    0x3,    0x9,    0x3,    0x9,    0x5,    0x9,    0xa5,
      0xa,   0x9,    0x3,    0xa,    0x3,    0xa,    0x3,    0xa,    0x3,
      0xa,   0x3,    0xa,    0x3,    0xa,    0x5,    0xa,    0xad,   0xa,
      0xa,   0x3,    0xb,    0x3,    0xb,    0x5,    0xb,    0xb1,   0xa,
      0xb,   0x3,    0xc,    0x3,    0xc,    0x3,    0xc,    0x7,    0xc,
      0xb6,  0xa,    0xc,    0xc,    0xc,    0xe,    0xc,    0xb9,   0xb,
      0xc,   0x3,    0xd,    0x3,    0xd,    0x5,    0xd,    0xbd,   0xa,
      0xd,   0x3,    0xe,    0x3,    0xe,    0x3,    0xe,    0x3,    0xe,
      0x5,   0xe,    0xc3,   0xa,    0xe,    0x3,    0xf,    0x3,    0xf,
      0x5,   0xf,    0xc7,   0xa,    0xf,    0x3,    0x10,   0x3,    0x10,
      0x3,   0x10,   0x3,    0x10,   0x7,    0x10,   0xcd,   0xa,    0x10,
      0xc,   0x10,   0xe,    0x10,   0xd0,   0xb,    0x10,   0x3,    0x10,
      0x3,   0x10,   0x3,    0x11,   0x3,    0x11,   0x5,    0x11,   0xd6,
      0xa,   0x11,   0x3,    0x12,   0x3,    0x12,   0x5,    0x12,   0xda,
      0xa,   0x12,   0x3,    0x13,   0x3,    0x13,   0x3,    0x13,   0x3,
      0x13,  0x3,    0x13,   0x7,    0x13,   0xe1,   0xa,    0x13,   0xc,
      0x13,  0xe,    0x13,   0xe4,   0xb,    0x13,   0x5,    0x13,   0xe6,
      0xa,   0x13,   0x3,    0x13,   0x3,    0x13,   0x3,    0x14,   0x3,
      0x14,  0x3,    0x15,   0x3,    0x15,   0x3,    0x15,   0x3,    0x15,
      0x5,   0x15,   0xf0,   0xa,    0x15,   0x3,    0x15,   0x5,    0x15,
      0xf3,  0xa,    0x15,   0x3,    0x15,   0x5,    0x15,   0xf6,   0xa,
      0x15,  0x3,    0x16,   0x3,    0x16,   0x3,    0x16,   0x7,    0x16,
      0xfb,  0xa,    0x16,   0xc,    0x16,   0xe,    0x16,   0xfe,   0xb,
      0x16,  0x3,    0x17,   0x3,    0x17,   0x3,    0x17,   0x5,    0x17,
      0x103, 0xa,    0x17,   0x3,    0x17,   0x5,    0x17,   0x106,  0xa,
      0x17,  0x5,    0x17,   0x108,  0xa,    0x17,   0x3,    0x18,   0x3,
      0x18,  0x3,    0x18,   0x3,    0x19,   0x3,    0x19,   0x3,    0x19,
      0x3,   0x19,   0x3,    0x19,   0x7,    0x19,   0x112,  0xa,    0x19,
      0xc,   0x19,   0xe,    0x19,   0x115,  0xb,    0x19,   0x3,    0x1a,
      0x3,   0x1a,   0x5,    0x1a,   0x119,  0xa,    0x1a,   0x3,    0x1b,
      0x3,   0x1b,   0x3,    0x1b,   0x3,    0x1c,   0x3,    0x1c,   0x3,
      0x1d,  0x3,    0x1d,   0x3,    0x1e,   0x3,    0x1e,   0x3,    0x1f,
      0x5,   0x1f,   0x125,  0xa,    0x1f,   0x3,    0x1f,   0x3,    0x1f,
      0x3,   0x20,   0x3,    0x20,   0x5,    0x20,   0x12b,  0xa,    0x20,
      0x3,   0x21,   0x3,    0x21,   0x3,    0x22,   0x3,    0x22,   0x3,
      0x23,  0x3,    0x23,   0x3,    0x24,   0x3,    0x24,   0x3,    0x25,
      0x3,   0x25,   0x3,    0x26,   0x3,    0x26,   0x3,    0x27,   0x3,
      0x27,  0x3,    0x27,   0x5,    0x27,   0x13c,  0xa,    0x27,   0x3,
      0x28,  0x3,    0x28,   0x3,    0x28,   0x5,    0x28,   0x141,  0xa,
      0x28,  0x3,    0x29,   0x3,    0x29,   0x3,    0x29,   0x2,    0x3,
      0xc,   0x2a,   0x2,    0x4,    0x6,    0x8,    0xa,    0xc,    0xe,
      0x10,  0x12,   0x14,   0x16,   0x18,   0x1a,   0x1c,   0x1e,   0x20,
      0x22,  0x24,   0x26,   0x28,   0x2a,   0x2c,   0x2e,   0x30,   0x32,
      0x34,  0x36,   0x38,   0x3a,   0x3c,   0x3e,   0x40,   0x42,   0x44,
      0x46,  0x48,   0x4a,   0x4c,   0x4e,   0x50,   0x2,    0x9,    0x3,
      0x2,   0x2b,   0x2b,   0x4,    0x2,    0x25,   0x25,   0x2b,   0x2b,
      0x3,   0x2,    0x7,    0x8,    0x3,    0x2,    0x11,   0x12,   0x3,
      0x2,   0x1a,   0x1b,   0x3,    0x2,    0x14,   0x15,   0x6,    0x2,
      0x3,   0x6,    0x9,    0xc,    0xe,    0x13,   0x3a,   0x3a,   0x2,
      0x149, 0x2,    0x53,   0x3,    0x2,    0x2,    0x2,    0x4,    0x5b,
      0x3,   0x2,    0x2,    0x2,    0x6,    0x61,   0x3,    0x2,    0x2,
      0x2,   0x8,    0x64,   0x3,    0x2,    0x2,    0x2,    0xa,    0x66,
      0x3,   0x2,    0x2,    0x2,    0xc,    0x6c,   0x3,    0x2,    0x2,
      0x2,   0xe,    0x79,   0x3,    0x2,    0x2,    0x2,    0x10,   0xa4,
      0x3,   0x2,    0x2,    0x2,    0x12,   0xac,   0x3,    0x2,    0x2,
      0x2,   0x14,   0xb0,   0x3,    0x2,    0x2,    0x2,    0x16,   0xb2,
      0x3,   0x2,    0x2,    0x2,    0x18,   0xbc,   0x3,    0x2,    0x2,
      0x2,   0x1a,   0xc2,   0x3,    0x2,    0x2,    0x2,    0x1c,   0xc6,
      0x3,   0x2,    0x2,    0x2,    0x1e,   0xc8,   0x3,    0x2,    0x2,
      0x2,   0x20,   0xd5,   0x3,    0x2,    0x2,    0x2,    0x22,   0xd9,
      0x3,   0x2,    0x2,    0x2,    0x24,   0xdb,   0x3,    0x2,    0x2,
      0x2,   0x26,   0xe9,   0x3,    0x2,    0x2,    0x2,    0x28,   0xeb,
      0x3,   0x2,    0x2,    0x2,    0x2a,   0xf7,   0x3,    0x2,    0x2,
      0x2,   0x2c,   0x107,  0x3,    0x2,    0x2,    0x2,    0x2e,   0x109,
      0x3,   0x2,    0x2,    0x2,    0x30,   0x10c,  0x3,    0x2,    0x2,
      0x2,   0x32,   0x116,  0x3,    0x2,    0x2,    0x2,    0x34,   0x11a,
      0x3,   0x2,    0x2,    0x2,    0x36,   0x11d,  0x3,    0x2,    0x2,
      0x2,   0x38,   0x11f,  0x3,    0x2,    0x2,    0x2,    0x3a,   0x121,
      0x3,   0x2,    0x2,    0x2,    0x3c,   0x124,  0x3,    0x2,    0x2,
      0x2,   0x3e,   0x12a,  0x3,    0x2,    0x2,    0x2,    0x40,   0x12c,
      0x3,   0x2,    0x2,    0x2,    0x42,   0x12e,  0x3,    0x2,    0x2,
      0x2,   0x44,   0x130,  0x3,    0x2,    0x2,    0x2,    0x46,   0x132,
      0x3,   0x2,    0x2,    0x2,    0x48,   0x134,  0x3,    0x2,    0x2,
      0x2,   0x4a,   0x136,  0x3,    0x2,    0x2,    0x2,    0x4c,   0x13b,
      0x3,   0x2,    0x2,    0x2,    0x4e,   0x140,  0x3,    0x2,    0x2,
      0x2,   0x50,   0x142,  0x3,    0x2,    0x2,    0x2,    0x52,   0x54,
      0xa,   0x2,    0x2,    0x2,    0x53,   0x52,   0x3,    0x2,    0x2,
      0x2,   0x54,   0x55,   0x3,    0x2,    0x2,    0x2,    0x55,   0x53,
      0x3,   0x2,    0x2,    0x2,    0x55,   0x56,   0x3,    0x2,    0x2,
      0x2,   0x56,   0x3,    0x3,    0x2,    0x2,    0x2,    0x57,   0x59,
      0x5,   0x8,    0x5,    0x2,    0x58,   0x5a,   0x9,    0x3,    0x2,
      0x2,   0x59,   0x58,   0x3,    0x2,    0x2,    0x2,    0x59,   0x5a,
      0x3,   0x2,    0x2,    0x2,    0x5a,   0x5c,   0x3,    0x2,    0x2,
      0x2,   0x5b,   0x57,   0x3,    0x2,    0x2,    0x2,    0x5c,   0x5d,
      0x3,   0x2,    0x2,    0x2,    0x5d,   0x5b,   0x3,    0x2,    0x2,
      0x2,   0x5d,   0x5e,   0x3,    0x2,    0x2,    0x2,    0x5e,   0x5f,
      0x3,   0x2,    0x2,    0x2,    0x5f,   0x60,   0x7,    0x2,    0x2,
      0x3,   0x60,   0x5,    0x3,    0x2,    0x2,    0x2,    0x61,   0x62,
      0x5,   0xc,    0x7,    0x2,    0x62,   0x63,   0x7,    0x2,    0x2,
      0x3,   0x63,   0x7,    0x3,    0x2,    0x2,    0x2,    0x64,   0x65,
      0x5,   0x26,   0x14,   0x2,    0x65,   0x9,    0x3,    0x2,    0x2,
      0x2,   0x66,   0x67,   0x7,    0xb,    0x2,    0x2,    0x67,   0x68,
      0x5,   0xc,    0x7,    0x2,    0x68,   0xb,    0x3,    0x2,    0x2,
      0x2,   0x69,   0x6a,   0x8,    0x7,    0x1,    0x2,    0x6a,   0x6d,
      0x5,   0x10,   0x9,    0x2,    0x6b,   0x6d,   0x5,    0xe,    0x8,
      0x2,   0x6c,   0x69,   0x3,    0x2,    0x2,    0x2,    0x6c,   0x6b,
      0x3,   0x2,    0x2,    0x2,    0x6d,   0x76,   0x3,    0x2,    0x2,
      0x2,   0x6e,   0x6f,   0xc,    0x5,    0x2,    0x2,    0x6f,   0x70,
      0x7,   0x4,    0x2,    0x2,    0x70,   0x75,   0x5,    0xc,    0x7,
      0x6,   0x71,   0x72,   0xc,    0x4,    0x2,    0x2,    0x72,   0x73,
      0x7,   0x3,    0x2,    0x2,    0x73,   0x75,   0x5,    0xc,    0x7,
      0x5,   0x74,   0x6e,   0x3,    0x2,    0x2,    0x2,    0x74,   0x71,
      0x3,   0x2,    0x2,    0x2,    0x75,   0x78,   0x3,    0x2,    0x2,
      0x2,   0x76,   0x74,   0x3,    0x2,    0x2,    0x2,    0x76,   0x77,
      0x3,   0x2,    0x2,    0x2,    0x77,   0xd,    0x3,    0x2,    0x2,
      0x2,   0x78,   0x76,   0x3,    0x2,    0x2,    0x2,    0x79,   0x7a,
      0x7,   0x1d,   0x2,    0x2,    0x7a,   0x7b,   0x5,    0xc,    0x7,
      0x2,   0x7b,   0x7c,   0x7,    0x1e,   0x2,    0x2,    0x7c,   0xf,
      0x3,   0x2,    0x2,    0x2,    0x7d,   0x7e,   0x5,    0x48,   0x25,
      0x2,   0x7e,   0x7f,   0x5,    0x12,   0xa,    0x2,    0x7f,   0x80,
      0x5,   0x14,   0xb,    0x2,    0x80,   0xa5,   0x3,    0x2,    0x2,
      0x2,   0x81,   0x82,   0x5,    0x48,   0x25,   0x2,    0x82,   0x83,
      0x7,   0xa,    0x2,    0x2,    0x83,   0x84,   0x5,    0x14,   0xb,
      0x2,   0x84,   0xa5,   0x3,    0x2,    0x2,    0x2,    0x85,   0x87,
      0x5,   0x48,   0x25,   0x2,    0x86,   0x88,   0x7,    0x5,    0x2,
      0x2,   0x87,   0x86,   0x3,    0x2,    0x2,    0x2,    0x87,   0x88,
      0x3,   0x2,    0x2,    0x2,    0x88,   0x89,   0x3,    0x2,    0x2,
      0x2,   0x89,   0x8a,   0x7,    0x6,    0x2,    0x2,    0x8a,   0x8b,
      0x7,   0x1d,   0x2,    0x2,    0x8b,   0x8c,   0x5,    0x16,   0xc,
      0x2,   0x8c,   0x8d,   0x7,    0x1e,   0x2,    0x2,    0x8d,   0xa5,
      0x3,   0x2,    0x2,    0x2,    0x8e,   0x90,   0x5,    0x48,   0x25,
      0x2,   0x8f,   0x91,   0x7,    0x5,    0x2,    0x2,    0x90,   0x8f,
      0x3,   0x2,    0x2,    0x2,    0x90,   0x91,   0x3,    0x2,    0x2,
      0x2,   0x91,   0x92,   0x3,    0x2,    0x2,    0x2,    0x92,   0x93,
      0x9,   0x4,    0x2,    0x2,    0x93,   0x95,   0x7,    0x1d,   0x2,
      0x2,   0x94,   0x96,   0x5,    0x16,   0xc,    0x2,    0x95,   0x94,
      0x3,   0x2,    0x2,    0x2,    0x95,   0x96,   0x3,    0x2,    0x2,
      0x2,   0x96,   0x97,   0x3,    0x2,    0x2,    0x2,    0x97,   0x98,
      0x7,   0x1e,   0x2,    0x2,    0x98,   0xa5,   0x3,    0x2,    0x2,
      0x2,   0x99,   0x9a,   0x5,    0x48,   0x25,   0x2,    0x9a,   0x9c,
      0x7,   0x16,   0x2,    0x2,    0x9b,   0x9d,   0x7,    0x5,    0x2,
      0x2,   0x9c,   0x9b,   0x3,    0x2,    0x2,    0x2,    0x9c,   0x9d,
      0x3,   0x2,    0x2,    0x2,    0x9d,   0x9e,   0x3,    0x2,    0x2,
      0x2,   0x9e,   0x9f,   0x7,    0x17,   0x2,    0x2,    0x9f,   0xa5,
      0x3,   0x2,    0x2,    0x2,    0xa0,   0xa1,   0x5,    0x24,   0x13,
      0x2,   0xa1,   0xa2,   0x5,    0x12,   0xa,    0x2,    0xa2,   0xa3,
      0x5,   0x14,   0xb,    0x2,    0xa3,   0xa5,   0x3,    0x2,    0x2,
      0x2,   0xa4,   0x7d,   0x3,    0x2,    0x2,    0x2,    0xa4,   0x81,
      0x3,   0x2,    0x2,    0x2,    0xa4,   0x85,   0x3,    0x2,    0x2,
      0x2,   0xa4,   0x8e,   0x3,    0x2,    0x2,    0x2,    0xa4,   0x99,
      0x3,   0x2,    0x2,    0x2,    0xa4,   0xa0,   0x3,    0x2,    0x2,
      0x2,   0xa5,   0x11,   0x3,    0x2,    0x2,    0x2,    0xa6,   0xad,
      0x7,   0x33,   0x2,    0x2,    0xa7,   0xad,   0x5,    0x4a,   0x26,
      0x2,   0xa8,   0xad,   0x7,    0x31,   0x2,    0x2,    0xa9,   0xad,
      0x7,   0x32,   0x2,    0x2,    0xaa,   0xad,   0x5,    0x4e,   0x28,
      0x2,   0xab,   0xad,   0x5,    0x4c,   0x27,   0x2,    0xac,   0xa6,
      0x3,   0x2,    0x2,    0x2,    0xac,   0xa7,   0x3,    0x2,    0x2,
      0x2,   0xac,   0xa8,   0x3,    0x2,    0x2,    0x2,    0xac,   0xa9,
      0x3,   0x2,    0x2,    0x2,    0xac,   0xaa,   0x3,    0x2,    0x2,
      0x2,   0xac,   0xab,   0x3,    0x2,    0x2,    0x2,    0xad,   0x13,
      0x3,   0x2,    0x2,    0x2,    0xae,   0xb1,   0x5,    0x1a,   0xe,
      0x2,   0xaf,   0xb1,   0x5,    0x24,   0x13,   0x2,    0xb0,   0xae,
      0x3,   0x2,    0x2,    0x2,    0xb0,   0xaf,   0x3,    0x2,    0x2,
      0x2,   0xb1,   0x15,   0x3,    0x2,    0x2,    0x2,    0xb2,   0xb7,
      0x5,   0x18,   0xd,    0x2,    0xb3,   0xb4,   0x7,    0x24,   0x2,
      0x2,   0xb4,   0xb6,   0x5,    0x18,   0xd,    0x2,    0xb5,   0xb3,
      0x3,   0x2,    0x2,    0x2,    0xb6,   0xb9,   0x3,    0x2,    0x2,
      0x2,   0xb7,   0xb5,   0x3,    0x2,    0x2,    0x2,    0xb7,   0xb8,
      0x3,   0x2,    0x2,    0x2,    0xb8,   0x17,   0x3,    0x2,    0x2,
      0x2,   0xb9,   0xb7,   0x3,    0x2,    0x2,    0x2,    0xba,   0xbd,
      0x5,   0x1c,   0xf,    0x2,    0xbb,   0xbd,   0x5,    0x46,   0x24,
      0x2,   0xbc,   0xba,   0x3,    0x2,    0x2,    0x2,    0xbc,   0xbb,
      0x3,   0x2,    0x2,    0x2,    0xbd,   0x19,   0x3,    0x2,    0x2,
      0x2,   0xbe,   0xc3,   0x5,    0x3e,   0x20,   0x2,    0xbf,   0xc3,
      0x5,   0x44,   0x23,   0x2,    0xc0,   0xc3,   0x5,    0x20,   0x11,
      0x2,   0xc1,   0xc3,   0x5,    0x46,   0x24,   0x2,    0xc2,   0xbe,
      0x3,   0x2,    0x2,    0x2,    0xc2,   0xbf,   0x3,    0x2,    0x2,
      0x2,   0xc2,   0xc0,   0x3,    0x2,    0x2,    0x2,    0xc2,   0xc1,
      0x3,   0x2,    0x2,    0x2,    0xc3,   0x1b,   0x3,    0x2,    0x2,
      0x2,   0xc4,   0xc7,   0x5,    0x3e,   0x20,   0x2,    0xc5,   0xc7,
      0x5,   0x44,   0x23,   0x2,    0xc6,   0xc4,   0x3,    0x2,    0x2,
      0x2,   0xc6,   0xc5,   0x3,    0x2,    0x2,    0x2,    0xc7,   0x1d,
      0x3,   0x2,    0x2,    0x2,    0xc8,   0xc9,   0x7,    0x1f,   0x2,
      0x2,   0xc9,   0xce,   0x7,    0x37,   0x2,    0x2,    0xca,   0xcb,
      0x7,   0x24,   0x2,    0x2,    0xcb,   0xcd,   0x7,    0x37,   0x2,
      0x2,   0xcc,   0xca,   0x3,    0x2,    0x2,    0x2,    0xcd,   0xd0,
      0x3,   0x2,    0x2,    0x2,    0xce,   0xcc,   0x3,    0x2,    0x2,
      0x2,   0xce,   0xcf,   0x3,    0x2,    0x2,    0x2,    0xcf,   0xd1,
      0x3,   0x2,    0x2,    0x2,    0xd0,   0xce,   0x3,    0x2,    0x2,
      0x2,   0xd1,   0xd2,   0x7,    0x20,   0x2,    0x2,    0xd2,   0x1f,
      0x3,   0x2,    0x2,    0x2,    0xd3,   0xd6,   0x7,    0x37,   0x2,
      0x2,   0xd4,   0xd6,   0x5,    0x1e,   0x10,   0x2,    0xd5,   0xd3,
      0x3,   0x2,    0x2,    0x2,    0xd5,   0xd4,   0x3,    0x2,    0x2,
      0x2,   0xd6,   0x21,   0x3,    0x2,    0x2,    0x2,    0xd7,   0xda,
      0x5,   0x14,   0xb,    0x2,    0xd8,   0xda,   0x5,    0x48,   0x25,
      0x2,   0xd9,   0xd7,   0x3,    0x2,    0x2,    0x2,    0xd9,   0xd8,
      0x3,   0x2,    0x2,    0x2,    0xda,   0x23,   0x3,    0x2,    0x2,
      0x2,   0xdb,   0xdc,   0x5,    0x48,   0x25,   0x2,    0xdc,   0xe5,
      0x7,   0x1d,   0x2,    0x2,    0xdd,   0xe2,   0x5,    0x22,   0x12,
      0x2,   0xde,   0xdf,   0x7,    0x24,   0x2,    0x2,    0xdf,   0xe1,
      0x5,   0x22,   0x12,   0x2,    0xe0,   0xde,   0x3,    0x2,    0x2,
      0x2,   0xe1,   0xe4,   0x3,    0x2,    0x2,    0x2,    0xe2,   0xe0,
      0x3,   0x2,    0x2,    0x2,    0xe2,   0xe3,   0x3,    0x2,    0x2,
      0x2,   0xe3,   0xe6,   0x3,    0x2,    0x2,    0x2,    0xe4,   0xe2,
      0x3,   0x2,    0x2,    0x2,    0xe5,   0xdd,   0x3,    0x2,    0x2,
      0x2,   0xe5,   0xe6,   0x3,    0x2,    0x2,    0x2,    0xe6,   0xe7,
      0x3,   0x2,    0x2,    0x2,    0xe7,   0xe8,   0x7,    0x1e,   0x2,
      0x2,   0xe8,   0x25,   0x3,    0x2,    0x2,    0x2,    0xe9,   0xea,
      0x5,   0x28,   0x15,   0x2,    0xea,   0x27,   0x3,    0x2,    0x2,
      0x2,   0xeb,   0xec,   0x7,    0xc,    0x2,    0x2,    0xec,   0xed,
      0x5,   0x2a,   0x16,   0x2,    0xed,   0xef,   0x5,    0x2e,   0x18,
      0x2,   0xee,   0xf0,   0x5,    0xa,    0x6,    0x2,    0xef,   0xee,
      0x3,   0x2,    0x2,    0x2,    0xef,   0xf0,   0x3,    0x2,    0x2,
      0x2,   0xf0,   0xf2,   0x3,    0x2,    0x2,    0x2,    0xf1,   0xf3,
      0x5,   0x30,   0x19,   0x2,    0xf2,   0xf1,   0x3,    0x2,    0x2,
      0x2,   0xf2,   0xf3,   0x3,    0x2,    0x2,    0x2,    0xf3,   0xf5,
      0x3,   0x2,    0x2,    0x2,    0xf4,   0xf6,   0x5,    0x34,   0x1b,
      0x2,   0xf5,   0xf4,   0x3,    0x2,    0x2,    0x2,    0xf5,   0xf6,
      0x3,   0x2,    0x2,    0x2,    0xf6,   0x29,   0x3,    0x2,    0x2,
      0x2,   0xf7,   0xfc,   0x5,    0x2c,   0x17,   0x2,    0xf8,   0xf9,
      0x7,   0x24,   0x2,    0x2,    0xf9,   0xfb,   0x5,    0x2c,   0x17,
      0x2,   0xfa,   0xf8,   0x3,    0x2,    0x2,    0x2,    0xfb,   0xfe,
      0x3,   0x2,    0x2,    0x2,    0xfc,   0xfa,   0x3,    0x2,    0x2,
      0x2,   0xfc,   0xfd,   0x3,    0x2,    0x2,    0x2,    0xfd,   0x2b,
      0x3,   0x2,    0x2,    0x2,    0xfe,   0xfc,   0x3,    0x2,    0x2,
      0x2,   0xff,   0x108,  0x7,    0x21,   0x2,    0x2,    0x100,  0x102,
      0x5,   0x38,   0x1d,   0x2,    0x101,  0x103,  0x7,    0xe,    0x2,
      0x2,   0x102,  0x101,  0x3,    0x2,    0x2,    0x2,    0x102,  0x103,
      0x3,   0x2,    0x2,    0x2,    0x103,  0x105,  0x3,    0x2,    0x2,
      0x2,   0x104,  0x106,  0x5,    0x3c,   0x1f,   0x2,    0x105,  0x104,
      0x3,   0x2,    0x2,    0x2,    0x105,  0x106,  0x3,    0x2,    0x2,
      0x2,   0x106,  0x108,  0x3,    0x2,    0x2,    0x2,    0x107,  0xff,
      0x3,   0x2,    0x2,    0x2,    0x107,  0x100,  0x3,    0x2,    0x2,
      0x2,   0x108,  0x2d,   0x3,    0x2,    0x2,    0x2,    0x109,  0x10a,
      0x7,   0xd,    0x2,    0x2,    0x10a,  0x10b,  0x5,    0x36,   0x1c,
      0x2,   0x10b,  0x2f,   0x3,    0x2,    0x2,    0x2,    0x10c,  0x10d,
      0x7,   0x10,   0x2,    0x2,    0x10d,  0x10e,  0x7,    0xf,    0x2,
      0x2,   0x10e,  0x113,  0x5,    0x32,   0x1a,   0x2,    0x10f,  0x110,
      0x7,   0x24,   0x2,    0x2,    0x110,  0x112,  0x5,    0x32,   0x1a,
      0x2,   0x111,  0x10f,  0x3,    0x2,    0x2,    0x2,    0x112,  0x115,
      0x3,   0x2,    0x2,    0x2,    0x113,  0x111,  0x3,    0x2,    0x2,
      0x2,   0x113,  0x114,  0x3,    0x2,    0x2,    0x2,    0x114,  0x31,
      0x3,   0x2,    0x2,    0x2,    0x115,  0x113,  0x3,    0x2,    0x2,
      0x2,   0x116,  0x118,  0x5,    0x38,   0x1d,   0x2,    0x117,  0x119,
      0x9,   0x5,    0x2,    0x2,    0x118,  0x117,  0x3,    0x2,    0x2,
      0x2,   0x118,  0x119,  0x3,    0x2,    0x2,    0x2,    0x119,  0x33,
      0x3,   0x2,    0x2,    0x2,    0x11a,  0x11b,  0x7,    0x13,   0x2,
      0x2,   0x11b,  0x11c,  0x5,    0x40,   0x21,   0x2,    0x11c,  0x35,
      0x3,   0x2,    0x2,    0x2,    0x11d,  0x11e,  0x5,    0x48,   0x25,
      0x2,   0x11e,  0x37,   0x3,    0x2,    0x2,    0x2,    0x11f,  0x120,
      0x5,   0x48,   0x25,   0x2,    0x120,  0x39,   0x3,    0x2,    0x2,
      0x2,   0x121,  0x122,  0x5,    0x48,   0x25,   0x2,    0x122,  0x3b,
      0x3,   0x2,    0x2,    0x2,    0x123,  0x125,  0x7,    0xe,    0x2,
      0x2,   0x124,  0x123,  0x3,    0x2,    0x2,    0x2,    0x124,  0x125,
      0x3,   0x2,    0x2,    0x2,    0x125,  0x126,  0x3,    0x2,    0x2,
      0x2,   0x126,  0x127,  0x5,    0x48,   0x25,   0x2,    0x127,  0x3d,
      0x3,   0x2,    0x2,    0x2,    0x128,  0x12b,  0x5,    0x40,   0x21,
      0x2,   0x129,  0x12b,  0x5,    0x42,   0x22,   0x2,    0x12a,  0x128,
      0x3,   0x2,    0x2,    0x2,    0x12a,  0x129,  0x3,    0x2,    0x2,
      0x2,   0x12b,  0x3f,   0x3,    0x2,    0x2,    0x2,    0x12c,  0x12d,
      0x7,   0x18,   0x2,    0x2,    0x12d,  0x41,   0x3,    0x2,    0x2,
      0x2,   0x12e,  0x12f,  0x7,    0x19,   0x2,    0x2,    0x12f,  0x43,
      0x3,   0x2,    0x2,    0x2,    0x130,  0x131,  0x9,    0x6,    0x2,
      0x2,   0x131,  0x45,   0x3,    0x2,    0x2,    0x2,    0x132,  0x133,
      0x9,   0x7,    0x2,    0x2,    0x133,  0x47,   0x3,    0x2,    0x2,
      0x2,   0x134,  0x135,  0x5,    0x50,   0x29,   0x2,    0x135,  0x49,
      0x3,   0x2,    0x2,    0x2,    0x136,  0x137,  0x7,    0x2e,   0x2,
      0x2,   0x137,  0x4b,   0x3,    0x2,    0x2,    0x2,    0x138,  0x13c,
      0x7,   0x2d,   0x2,    0x2,    0x139,  0x13a,  0x7,    0x32,   0x2,
      0x2,   0x13a,  0x13c,  0x7,    0x33,   0x2,    0x2,    0x13b,  0x138,
      0x3,   0x2,    0x2,    0x2,    0x13b,  0x139,  0x3,    0x2,    0x2,
      0x2,   0x13c,  0x4d,   0x3,    0x2,    0x2,    0x2,    0x13d,  0x141,
      0x7,   0x2c,   0x2,    0x2,    0x13e,  0x13f,  0x7,    0x31,   0x2,
      0x2,   0x13f,  0x141,  0x7,    0x33,   0x2,    0x2,    0x140,  0x13d,
      0x3,   0x2,    0x2,    0x2,    0x140,  0x13e,  0x3,    0x2,    0x2,
      0x2,   0x141,  0x4f,   0x3,    0x2,    0x2,    0x2,    0x142,  0x143,
      0x9,   0x8,    0x2,    0x2,    0x143,  0x51,   0x3,    0x2,    0x2,
      0x2,   0x25,   0x55,   0x59,   0x5d,   0x6c,   0x74,   0x76,   0x87,
      0x90,  0x95,   0x9c,   0xa4,   0xac,   0xb0,   0xb7,   0xbc,   0xc2,
      0xc6,  0xce,   0xd5,   0xd9,   0xe2,   0xe5,   0xef,   0xf2,   0xf5,
      0xfc,  0x102,  0x105,  0x107,  0x113,  0x118,  0x124,  0x12a,  0x13b,
      0x140,
  };

  atn::ATNDeserializer deserializer;
  _atn = deserializer.deserialize(_serializedATN);

  size_t count = _atn.getNumberOfDecisions();
  _decisionToDFA.reserve(count);
  for (size_t i = 0; i < count; i++) {
    _decisionToDFA.emplace_back(_atn.getDecisionState(i), i);
  }
}

SQLParser::Initializer SQLParser::_init;
