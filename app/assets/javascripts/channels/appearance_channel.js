$(document).ready(function() {
    App.cable.subscriptions.create("AppearanceChannel", {
        // Called once when the subscription is created.
    initialized() {
        this.update = this.update.bind(this)
    },

    // Called when the subscription is ready for use on the server.
    connected() {
        this.install()
        this.update()
    },

    // Called when the WebSocket connection is closed.
    disconnected() {
        this.uninstall()
    },

    // Called when the subscription is rejected by the server.
    rejected() {
        this.uninstall()
    },

    update() {
        this.documentIsActive ? this.appear() : this.away()
    },

    appear() {
        // Calls `AppearanceChannel#appear(data)` on the server.
        this.perform("appear", { appearing_on: this.appearingOn })
    },

    away() {
        // Calls `AppearanceChannel#away` on the server.
        this.perform("away")
    },

    install() {
        window.addEventListener("focus", this.update)
        window.addEventListener("blur", this.update)
        document.addEventListener("turbo:load", this.update)
        document.addEventListener("visibilitychange", this.update)
    },

    uninstall() {
        window.removeEventListener("focus", this.update)
        window.removeEventListener("blur", this.update)
        document.removeEventListener("turbo:load", this.update)
        document.removeEventListener("visibilitychange", this.update)
    },

    get documentIsActive() {
        return document.visibilityState === "visible" && document.hasFocus()
    },

    get appearingOn() {
        const step = $(".js-step-link.step-current").attr('data-step')
        const formAnswerId = $('header.page-header').data('form-answer-id');
        const room = `form_answer_${formAnswerId}_step_${step}`;
        return room;
    }
  })
});
