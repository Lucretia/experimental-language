#include <iostream>

#include "antlr4-runtime.h"
#include "OrendaLexer.h"
#include "OrendaParser.h"

int main(int argc, char* argv[]) {
    antlr4::ANTLRInputStream inputStream(std::cin);
    orenda::OrendaLexer lexer(&inputStream);
    antlr4::CommonTokenStream tokens(&lexer);

    std::cout << "Start of scanning..." << std::endl << std::endl;

    for (std::unique_ptr<antlr4::Token>
            token = lexer.nextToken();
            token->getType() != antlr4::Token::EOF;
            token = lexer.nextToken()) {

        std::cout << "Token: " << std::setw(20) << std::left;

        switch (token->getType()) {
            case orenda::OrendaLexer::NL:
                std::cout << "<NL>";

                break;

            case orenda::OrendaLexer::WS:
                std::cout << "<WS>";

                break;

            case orenda::OrendaLexer::INTEGER_LIT:
                std::cout << "<INTEGER_LIT>" << '\'' << token->getText() << '\'';

                break;

            case orenda::OrendaLexer::REAL_LIT:
                std::cout << "<REAL_LIT>" << '\'' << token->getText() << '\'';

                break;

            default:
                std::cout << token->getType() << '\'' << token->getText() << '\'';
        }

        std::cout << std::endl;
    }

    std::cout << "Finished scanning." << std::endl;
}
