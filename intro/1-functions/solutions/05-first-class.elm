import Html exposing (div, text)

type alias User =
  { name : String
  , email : String
  }

richard = { name = "Richard", email = "richard@email.com" }
johnson = { name = "Johnson", email = "johnson@email.com" }
juliane = { name = "Juliane", email = "juliane@email.com" }
william = { name = "William", email = "william@email.com" }

transformUserName : (String -> String) -> User -> User
transformUserName f user = { user | name = f user.name }

smithize : String -> String
smithize name = name ++ " SMITH"

referenceName : String -> String
referenceName name = String.join ", " (List.reverse (String.words name))
-- or
-- referenceName name = name |> String.words |> List.reverse |> String.join ", "
-- or
-- referenceName name = String.join ", " << List.reverse << String.words

main =
  let
    users = [ richard, johnson, juliane, william ]

    usersHtml =
      users
      |> List.map (transformUserName smithize)
      |> List.map (transformUserName referenceName)
      |> List.map (\user -> div [] [ text user.name ])
  in
    div [] usersHtml
