.PHONY: shell build node_8000 node_8001

shell:
	./rebar3 shell

node_8000:
	./rebar3 shell --config config/node_8000.config --sname node_8000

node_8001:
	./rebar3 shell --config config/node_8001.config --sname node_8001
