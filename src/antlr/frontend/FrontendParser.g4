parser grammar FrontendParser;

options {
    tokenVocab = FrontendLexer;
}

// Document entry point - supports Jinja extends at start
document
    : jinjaExtendsStatement? DOCTYPE? content? EOF
    ;

// Content can be HTML, Jinja2, or CSS
content
    : contentItem*
    ;

contentItem
    : htmlElement
    | jinjaExpression
    | jinjaStatement
    | text
    ;

// HTML Element
htmlElement
    : TAG_OPEN tagName htmlAttribute* TAG_CLOSE content TAG_OPEN TAG_SLASH tagName TAG_CLOSE    # RegularElement
    | TAG_OPEN tagName htmlAttribute* TAG_SLASH TAG_CLOSE                                        # SelfClosingElement
    | styleElement                                                                               # Style
    ;

// Tag name can be identifier or CSS_IDENT (for custom elements with hyphens)
tagName
    : IDENTIFIER
    | CSS_IDENT
    ;

// HTML Attributes - support hyphenated attribute names
htmlAttribute
    : attrName (EQUALS attrValue)?
    ;

attrName
    : IDENTIFIER
    | CSS_IDENT
    ;

attrValue
    : STRING
    | IDENTIFIER
    | CSS_IDENT
    ;

// Style Element (CSS)
styleElement
    : TAG_OPEN STYLE_TAG TAG_CLOSE cssRule* TAG_OPEN TAG_SLASH STYLE_TAG TAG_CLOSE
    ;

// CSS Rules
cssRule
    : cssSelector CSS_LBRACE cssDeclaration* CSS_RBRACE
    ;

cssSelector
    : cssSelectorPart (COMMA cssSelectorPart)*
    ;

cssSelectorPart
    : cssSelectorItem+
    ;

cssSelectorItem
    : IDENTIFIER
    | CSS_IDENT
    | DOT IDENTIFIER
    | DOT CSS_IDENT
    | HASH IDENTIFIER
    | HASH CSS_IDENT
    ;

// CSS Declaration - supports hyphenated property names
cssDeclaration
    : cssPropertyName CSS_COLON cssValue+ CSS_SEMICOLON
    ;

cssPropertyName
    : IDENTIFIER
    | CSS_IDENT
    ;

cssValue
    : IDENTIFIER
    | CSS_IDENT
    | NUMBER CSS_UNIT?
    | HASH IDENTIFIER
    | HASH CSS_IDENT
    | HASH NUMBER
    | STRING
    ;

// Jinja2 Expression: {{ variable.attribute }}
jinjaExpression
    : JINJA_EXPR_START jinjaExpr JINJA_EXPR_END
    ;

jinjaExpr
    : IDENTIFIER                                            # JinjaIdentifier
    | jinjaExpr DOT IDENTIFIER                              # JinjaMemberAccess
    | jinjaExpr LBRACKET jinjaExpr RBRACKET                 # JinjaIndexAccess
    | STRING                                                # JinjaStringLiteral
    | NUMBER                                                # JinjaNumberLiteral
    ;

// Jinja2 Statements
jinjaStatement
    : jinjaIfStatement
    | jinjaForStatement
    | jinjaBlockStatement
    ;

// {% if condition %} ... {% endif %}
jinjaIfStatement
    : JINJA_STMT_START JINJA_IF jinjaCondition JINJA_STMT_END
      content
      jinjaElifStatement*
      jinjaElseStatement?
      JINJA_STMT_START JINJA_ENDIF JINJA_STMT_END
    ;

jinjaElifStatement
    : JINJA_STMT_START JINJA_ELIF jinjaCondition JINJA_STMT_END content
    ;

jinjaElseStatement
    : JINJA_STMT_START JINJA_ELSE JINJA_STMT_END content
    ;

// {% for item in collection %} ... {% endfor %}
jinjaForStatement
    : JINJA_STMT_START JINJA_FOR IDENTIFIER JINJA_IN jinjaStmtExpr JINJA_STMT_END
      content
      JINJA_STMT_START JINJA_ENDFOR JINJA_STMT_END
    ;

// {% extends "base.html" %}
jinjaExtendsStatement
    : JINJA_STMT_START JINJA_EXTENDS STRING JINJA_STMT_END
    ;

// {% block name %} ... {% endblock %}
jinjaBlockStatement
    : JINJA_STMT_START JINJA_BLOCK IDENTIFIER JINJA_STMT_END
      content
      JINJA_STMT_START JINJA_ENDBLOCK JINJA_STMT_END
    ;

// Jinja2 Conditions
//todo: make it labels
jinjaCondition
    : jinjaStmtExpr ((JINJA_EQ | JINJA_NEQ | JINJA_LT | JINJA_GT | JINJA_LTE | JINJA_GTE) jinjaStmtExpr)?
    | jinjaCondition JINJA_AND jinjaCondition
    | jinjaCondition JINJA_OR jinjaCondition
    | JINJA_NOT jinjaCondition
    ;

// Jinja2 Statement Expressions
jinjaStmtExpr
    : IDENTIFIER                                            # JinjaStmtIdentifier
    | jinjaStmtExpr DOT IDENTIFIER                          # JinjaStmtMemberAccess
    | jinjaStmtExpr LBRACKET jinjaStmtExpr RBRACKET         # JinjaStmtIndexAccess
    | STRING                                                # JinjaStmtStringLiteral
    | NUMBER                                                # JinjaStmtNumberLiteral
    ;

// Text content
text
    : TEXT
    | NUMBER
    | IDENTIFIER
    | CSS_IDENT
    ;
