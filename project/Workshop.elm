module Workshop exposing (..)

pure : model -> (model, Cmd msg)
pure a = a ! []
