import Html exposing (div, text)

type alias User =
  { name : String
  , email : String
  }

richard = { name = "Richard", email = "richard@email.com" }
johnson = { name = "Johnson", email = "johnson@email.com" }
juliane = { name = "Juliane", email = "juliane@email.com" }
william = { name = "William", email = "william@email.com" }

-- This function must perform an operation on a user's email.
-- The syntax for modifying records in Elm is: { record | field = value }.
transformUserName : (String -> String) -> User -> User
transformUserName = Debug.crash "Not implemented yet"

-- This function must append a capitalized surname Smith to a name.
smithize : String -> String
smithize = Debug.crash "Not implemented yet"

-- This function must convert a given name to its bibliographic reference form.
-- e.g.: Brian McJohnes -> MCJOHNES, Brian.
--
-- This function must be implemented using the following functions:
--   String.words :: String -> List String
--   List.reverse :: List a -> List a
--   String.join :: String -> List String -> String
referenceName : String -> String
referenceName = Debug.crash "Not implemented yet"

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
