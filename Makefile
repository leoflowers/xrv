xrv: xrv.ml
	ocamlopt -I +unix unix.cmxa -o xrv xrv.ml

clean:
	rm -rf xrv.cmi xrv.cmx xrv.o xrv