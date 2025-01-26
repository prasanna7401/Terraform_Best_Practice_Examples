name="prasanna"
games = ["ghost of tsushima", "god of war", "uncharted 4"]
game_map = {
    "ghost of tsushima" = "japan",
    "god of war" = "norse",
    "uncharted 4" = "madagascar"
}


#example run:

# terraform console

# > var.name
# prasanna

# for-loop example:
# > [for game in var.games: game]

# map example:
# > var.game_map["god of war"]
# norse

# splat example:
# > var.games[*]
# [
#   "ghost of tsushima",
#   "god of war",
#   "uncharted 4",
# ]

