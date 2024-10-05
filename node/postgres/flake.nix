{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          nodejs
          postgresql
        ];

        shellHook = ''
          export PGHOST=$PWD/.postgres
          export PGDATA=$PGHOST/data
          export PGDATABASE=postgres
          export PGLOG=$PGHOST/postgres.log

          mkdir -p $PGHOST

          if [ ! -d $PGDATA ]; then
            initdb --auth=trust --no-locale --encoding=UTF8
          fi

          if ! pgctl status
          then
            pg_ctl start -l $PGLOG -o "--unix_socket_directories='$PGHOST'"
          fi

          echo "Postgresql server running at `.postgres/socket`, data stored at `.postgres`."
          echo "You may connect with `psql`."
        '';
      };
    }
  );
}