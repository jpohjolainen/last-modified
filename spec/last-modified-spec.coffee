{WorkspaceView} = require 'atom'
Lastmodified = require '../lib/lastmodified'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Lastmodified", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('lastmodified')

  describe "when the lastmodified:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.lastmodified')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'lastmodified:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.lastmodified')).toExist()
        atom.workspaceView.trigger 'lastmodified:toggle'
        expect(atom.workspaceView.find('.lastmodified')).not.toExist()
