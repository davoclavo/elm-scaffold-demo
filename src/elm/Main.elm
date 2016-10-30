port module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Char exposing (..)
import Json.Decode as Json


-- port for sending strings out to JavaScript
port alert : String -> Cmd msg

main : Program Never
main =
  App.program { init = init
              , update = update
              , view = view
              , subscriptions = always Sub.none
              }

-- MODEL

init : ( Model, Cmd a )
init =
  { content = "" } ! []

type alias Model =
  { content : String
  }

-- UPDATE

type Msg = KeyUp (KeyCode, String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    KeyUp (13, _) ->
      { model | content = "" } ! [alert model.content]
    KeyUp (_, value) ->
      { model | content = value } ! []

onKeyUp : ((KeyCode, String) -> a) -> Attribute a
onKeyUp tag = on "keyup" <| Json.map tag <| Json.object2 (,) keyCode targetValue
-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [text "Enter message to send to JS so it displays it in alert"]
    , input [value model.content, onKeyUp KeyUp] []
    ]

