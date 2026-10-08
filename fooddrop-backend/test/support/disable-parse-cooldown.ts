// Side-effect module: import it FIRST in a spec. ConfigModule.forRoot validates the env when app.module.ts is
// evaluated, so assigning process.env in the spec body (after its hoisted imports) would come too late.
process.env['PARSER_COOLDOWN_SECONDS'] = '0';
