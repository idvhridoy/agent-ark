
// Generated from SQLLexer.g4 by ANTLR 4.8

#pragma once


#include "antlr4-runtime.h"


namespace antlr4 {


class SQLLexer : public antlr4::Lexer {
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

  enum { COMMENTS = 2 };

  SQLLexer(antlr4::CharStream *input);
  ~SQLLexer();

  virtual std::string getGrammarFileName() const override;
  virtual const std::vector<std::string> &getRuleNames() const override;

  virtual const std::vector<std::string> &getChannelNames() const override;
  virtual const std::vector<std::string> &getModeNames() const override;
  virtual const std::vector<std::string> &getTokenNames()
      const override;  // deprecated, use vocabulary instead
  virtual antlr4::dfa::Vocabulary &getVocabulary() const override;

  virtual const std::vector<uint16_t> getSerializedATN() const override;
  virtual const antlr4::atn::ATN &getATN() const override;

 private:
  static std::vector<antlr4::dfa::DFA> _decisionToDFA;
  static antlr4::atn::PredictionContextCache _sharedContextCache;
  static std::vector<std::string> _ruleNames;
  static std::vector<std::string> _tokenNames;
  static std::vector<std::string> _channelNames;
  static std::vector<std::string> _modeNames;

  static std::vector<std::string> _literalNames;
  static std::vector<std::string> _symbolicNames;
  static antlr4::dfa::Vocabulary _vocabulary;
  static antlr4::atn::ATN _atn;
  static std::vector<uint16_t> _serializedATN;


  // Individual action functions triggered by action() above.

  // Individual semantic predicate functions triggered by sempred() above.

  struct Initializer {
    Initializer();
  };
  static Initializer _init;
};

}  // namespace antlr4
