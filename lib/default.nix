{lib}:
lib.extend (self: _: let
  inherit (self) attrNames attrValues genAttrs head mapAttrs;
in {
  kkts = {
    forEachSystem = systems: f: let
      perSystemOutputs = genAttrs systems f;
      outputNames = attrValues perSystemOutputs |> head |> attrNames;
    in
      genAttrs outputNames (outputName:
        mapAttrs (_: systemOutputs: systemOutputs.${outputName}) perSystemOutputs);
  };
})
