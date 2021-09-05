import resolve from "@rollup/plugin-node-resolve"
import typescript from "@rollup/plugin-typescript"

export default [
  {
    external: ['turbolinks'],
    input: "src/index.ts",
    output: [
      {
        name: "Shoelace Rails",
        file: "dist/shoelace-rails.es5-umd.js",
        format: "umd",
        sourcemap: true,
      }
    ],
    plugins: [
      resolve(),
      typescript({ target: "es5", downlevelIteration: true })
    ],
    watch: {
      include: "src/**"
    }
  },

  {
    external: ['turbolinks'],
    input: "src/index.ts",
    output: [
      {
        name: "Shoelace Rails",
        file: "dist/shoelace-rails.es2017-umd.js",
        format: "umd",
        sourcemap: true,
      },
      {
        file: "dist/shoelace-rails.es2017-esm.js",
        format: "es",
        sourcemap: true,
      }
    ],
    plugins: [
      resolve(),
      typescript()
    ],
    watch: {
      include: "src/**"
    }
  }
]
