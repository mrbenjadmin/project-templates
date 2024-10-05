{
  description = "A few useful flake templates to get projects running quicker";

  outputs = {
    templates = {
      # node
      node = {
        path = node/base;
        description = "Simple node.js template";
      };
      node-postgres = {
        path = node/postgres;
        description = "Node.js template with postgresql server";
      };
    };
  }
}