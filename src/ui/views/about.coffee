ipc    = require('electron').ipcRenderer
path   = require 'path'
i18n   = require 'i18n'
remote = require('electron').remote
Menu   = remote.Menu
React  = require('react')

{check, versionToInt} = require '../version'

module.exports = view (models) ->

    # simple context menu that can only copy
    remote.getCurrentWindow().webContents.on 'context-menu', (e, params) ->
        e.preventDefault()
        menuTemplate = [{
            label: 'Copy'
            role: 'copy'
            enabled: params.editFlags.canCopy
        }
        {
            label: "Copy Link"
            visible: params.linkURL != '' and params.mediaType == 'none'
            click: () ->
                if process.platform == 'darwin'
                    clipboard
                    .writeBookmark params.linkText, params.linkText
                else
                    clipboard.writeText params.linkText
        }]
        Menu.buildFromTemplate(menuTemplate).popup remote.getCurrentWindow()

    #
    # decide if should update
    localVersion    = remote.require('electron').app.getVersion()
    releasedVersion = window.localStorage.versionAdvertised
    shouldUpdate    = releasedVersion? && localVersion? &&
                      versionToInt(releasedVersion) > versionToInt(localVersion)
    #
    div id: 'about-react', class: 'about', 'nothing to see here'

#$('document').on 'click', '.link-out', (ev)->
#
