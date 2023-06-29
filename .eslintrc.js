module.exports = {
    root: true,
    env: {
        browser: true,
        node: true,
    },
    parser: 'vue-eslint-parser',
    parserOptions: {
        parser: '@typescript-eslint/parser',
    },
    extends: ['@nuxtjs/eslint-config-typescript', 'plugin:prettier/recommended'],
    plugins: ['prettier'],
    rules: {
            // Enforce semi-colons
            semi: ['error', 'always'],

            // Disallow console.log()
            'no-console': 'error',

            // Add dangling commas to arrays
            'comma-dangle': ['error', 'always-multiline'],
    },
};