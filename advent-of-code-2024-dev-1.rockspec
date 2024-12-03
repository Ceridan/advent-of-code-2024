rockspec_format = "3.0"
package = "advent-of-code-2024"
version = "dev-1"
source = {
   url = "git+https://github.com/Ceridan/advent-of-code-2024"
}
description = {
   summary = "My solutions for Advent of Code 2024 puzzles.",
   homepage = "https://github.com/Ceridan/advent-of-code-2024",
   license = "MIT"
}
dependencies = {
   "lua == 5.1",
   "luaformatter == scm-1",
   "luacheck >= 1.2",
   "inspect >= 3.1",
   "http >= 0.4",
   "regex >= 0.2"
}
