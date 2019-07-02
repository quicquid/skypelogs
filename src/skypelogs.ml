let process_msg = function
  | `Assoc [
          ("id", _);
          ("displayName",_);
          ("originalarrivaltime", `String time);
          ("messagetype", `String mtype);
          ("version", _);
          ("content", `String content);
          ("conversationid", _);
          ("from", `String from);
          ("properties", _);
          ("amsreferences", _)
        ] -> (time, from, mtype, content)
  | _ -> failwith "Can't parse msg!"


let process_conv = function
  | `Assoc [("id", `String id);
            ("displayName", _);
            ("version", _);
            ("properties", _);
            ("threadProperties",_);
            ("messages",_);
            ("MessageList", `List msgs)
           ] ->
    (id, List.map process_msg msgs)
  | el ->
    let msg = CCFormat.asprintf "Can't parse conv: %a" Yojson.Basic.pp el in
    failwith msg




let dump = function
  | `Assoc [("userId", `String uid);
            ("exportDate", `String date);
            ("conversations", `List convs)
           ] ->
    (uid, date,List.map process_conv convs )
  | _ -> failwith "Can't parse main body!"

;;
let json = Yojson.Basic.from_channel stdin in
let (uid, _, convs) = dump json in
Printf.printf "user id: %s\n" uid;
List.map (function (id, msgs) ->
    Printf.printf "==== Conversation %s ====\n\n" id;
    msgs |> List.rev |> List.map (function
        | (time, name, "RichText", msg) ->
          Printf.printf "%s  %s: %s\n" time name msg
        | _ -> ()
      )
  ) convs |> ignore
