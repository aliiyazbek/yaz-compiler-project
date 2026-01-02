lexer grammar FrontendLexer;

// DOCTYPE
DOCTYPE: '<!DOCTYPE' [ ]+ 'html>';

// Jinja2 Template Delimiters
JINJA_EXPR_START: '{{';
JINJA_EXPR_END: '}}';
JINJA_STMT_START: '{%';
JINJA_STMT_END: '%}';
JINJA_COMMENT: '{#' .*? '#}' -> skip;

// Jinja2 Keywords (must come before IDENTIFIER)
JINJA_IF: 'if';
JINJA_ELIF: 'elif';
JINJA_ELSE: 'else';
JINJA_ENDIF: 'endif';
JINJA_FOR: 'for';
JINJA_IN: 'in';
JINJA_ENDFOR: 'endfor';
JINJA_EXTENDS: 'extends';
JINJA_BLOCK: 'block';
JINJA_ENDBLOCK: 'endblock';

// HTML/CSS Tag markers
TAG_OPEN: '<';
TAG_CLOSE: '>';
TAG_SLASH: '/';
STYLE_TAG: 'style';

// Jinja2 Operators (order matters - multi-char first)
JINJA_EQ: '==';
JINJA_NEQ: '!=';
JINJA_LTE: '<=';
JINJA_GTE: '>=';
JINJA_LT: '<';
JINJA_GT: '>';
JINJA_AND: 'and';
JINJA_OR: 'or';
JINJA_NOT: 'not';

// CSS Delimiters
CSS_LBRACE: '{';
CSS_RBRACE: '}';
CSS_COLON: ':';
CSS_SEMICOLON: ';';

// Common Delimiters
EQUALS: '=';
DOT: '.';
LBRACKET: '[';
RBRACKET: ']';
COMMA: ',';
HASH: '#';

// Literals
STRING: '"' (~["\r\n\\] | '\\' .)* '"'
      | '\'' (~['\r\n\\] | '\\' .)* '\'';

NUMBER: [0-9]+ ('.' [0-9]+)?;

// CSS Units
CSS_UNIT: 'px' | '%' | 'em' | 'rem';

// CSS Identifier (supports hyphens for CSS property names and class names)
// Must come before regular IDENTIFIER
CSS_IDENT: [a-zA-Z] [a-zA-Z0-9]* ('-' [a-zA-Z0-9]+)+;

// Identifiers (must come after keywords and CSS_IDENT)
IDENTIFIER: [a-zA-Z_][a-zA-Z0-9_]*;

// Text content - punctuation only (words match as IDENTIFIER)
TEXT: [,!?;:@]+;

// Whitespace
WS: [ \t\r\n]+ -> skip;

// Comments
HTML_COMMENT: '<!--' .*? '-->' -> skip;
CSS_COMMENT: '/*' .*? '*/' -> skip;
