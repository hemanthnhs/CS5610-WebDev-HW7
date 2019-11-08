import socket from './socket';
import store from './store';

let channel = null;

export function get_channel() {
    return channel;
}

export function join_channel(user_id, update_sheets) {
    channel = socket.channel("sheets:" + user_id, {});
    channel.join()
        .receive("ok", resp => {
            console.log("Joined Channel");})
        .receive("error", resp => {
            console.log("Unable to join", resp);
        });
    channel.on("less_hours_alert", function (data) {
        store.dispatch({
            type: 'NEW_ALERTS',
            data: data
        });
    })
    channel.on("update_sheets", update_sheets);
}