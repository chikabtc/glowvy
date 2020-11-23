module.exports = {
  env: {
    browser: true,
    commonjs: true,
    es2021: true,
  },
  extends: ['airbnb-base'],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 12,
  },
  plugins: ['@typescript-eslint'],
  rules: {
    'no-console': 'off',
    'no-restricted-syntax': 0,
    'max-len': 0,
    'no-await-in-loop': 0,
    'import/first': 0,
    'import/extensions': 0,
    'no-param-reassign': 0,
    'import/no-unresolved': 0,
    'no-unused-vars': [1, {
      varsIgnorePattern: '^_',
    }],
    '@typescript-eslint/no-unused-vars': [1, {
      varsIgnorePattern: '^_',
    }],
  },
  settings: {
    'import/resolver': {
      node: {
        path: ['src'],
        extensions: ['.js', '.jsx', '.ts', '.tsx'],
      },
    },
  },
};

/* eslint-disable eol-last */