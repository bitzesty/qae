// App.collaborators = App.cable.subscriptions.create({ channel: "CollaboratorsChannel", channel_name: "thing" }, {
//     connected() {
//         console.log("connected from the assets/javascripts file")
//     },

//     received(data) {
//         console.log("receieved data", data)
//     },

//     initRoom(channelName) {
//         this.perform('init_room', { channel_name: channelName })
//     },

//     addCollaborator(collaborator) {
//         this.perform('add_collaborator', { collaborator: collaborator })
//     },
// },
// )