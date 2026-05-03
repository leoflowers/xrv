open Unix

type status =
  | Clean
  | Dirty

let runwithoutput cmd =
  let ic = Unix.open_process_in cmd in 
  let result =
    try
      In_channel.input_all ic
    with e ->
      ignore (Unix.close_process_in ic);
      raise e
  in
  ignore (Unix.close_process_in ic);
  result

let runwithreturncode cmd : int =
  match Unix.system cmd with
    | Unix.WEXITED(rc) -> rc
    | _ -> -1

let gitstatus () : status =
  let result = runwithoutput "git status --porcelain | wc -l" in 
  if (int_of_string (String.trim result)) >= 1 then 
    Dirty
  else 
    Clean

let gitaddall () =
  match runwithreturncode "git add --all" with
    | 0 -> ()
    | _ -> failwith "could not add files"

let gitcommit msg =
  let cmd = Filename.quote_command "git" ["commit"; "-m"; msg] in
  match runwithreturncode cmd with
    | 0 -> ()
    | _ -> failwith "could not commit"

let gitpush () = 
  match runwithreturncode "git push" with
    | 0 -> ()
    | _ -> failwith "could not push"

let removehead xs =
  match xs with
    | [] -> failwith "empty list"
    | _ :: xs -> xs

let getdirup path =
  let path = List.rev (String.split_on_char '/' path) in
  match removehead path with
    | [] -> failwith "empty path"
    | [x] -> failwith "path is too shallow"
    | x :: xs -> String.concat "/" (List.rev xs)

let () = 
  let prog = Unix.realpath Sys.argv.(0) in
  let dir = getdirup prog in  
  Unix.chdir dir;
  print_endline ("directory to archive: " ^ (Unix.getcwd ()));

  match gitstatus () with
    | Dirty -> 
      gitaddall ();
      gitcommit "[autocommitted]";
      gitpush ();
    | Clean -> () 
