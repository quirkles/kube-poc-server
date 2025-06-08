import { readFileSync } from "fs";
import { join } from "path";
import {
    z
} from "zod"
import * as process from "node:process";
import { existsSync } from "node:fs";

const configSchema = z.object({
    frontendUrl: z.string(),
    env: z.enum(['local', 'dev', 'prod'])
});

type Config = z.infer<typeof configSchema>;

let config: Config | null = null;

export function getAppConfig(): Config {
    if(config) {
        return config;
    }
    const unvalidated: Record<string, string> = {}
    const repoRoot = join(__dirname, '..')
    const baseEnv = join(repoRoot, '.env')
    const baseEnvDict = parseEnv(baseEnv)
    Object.assign(unvalidated, baseEnvDict)
    if(process.env.NODE_ENV) {
        const env = join(repoRoot, `.env.${process.env.NODE_ENV.toLowerCase()}`)
        const envDict = parseEnv(env)
        Object.assign(unvalidated, envDict)
    }
    config = configSchema.parse({
        frontendUrl: unvalidated.FRONTEND_HOST,
        env: (process.env.NODE_ENV || 'local').toLowerCase()
    })
    return config;
}

function parseEnv(pathToEnvFile: string): Record<string, string> {
    const parsed: Record<string, string> = {}
    if(!existsSync(pathToEnvFile)) {
        return parsed;
    }
    const envFileContents = readFileSync(pathToEnvFile)
    const keyPairRegex = /^\s*([\w_]+)\s*=\s*(.*)?\s*$/gm
    let match
    while((match = keyPairRegex.exec(envFileContents.toString())) !== null) {
        parsed[match[1]] = match[2]
    }
    return parsed;
}
