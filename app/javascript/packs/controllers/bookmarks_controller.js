import { Controller } from 'stimulus'

export default class extends Controller {

  addBookmark(event) {
    event.preventDefault();
    let [video_id, user_id] = event.target.id.split(" ")
    debugger;
    fetch(`/api/v1/bookmarks/${video_id}/${user_id}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body:""
    })
      .then((response) => response.json())
      .then(function(response){
        console.log("hello");
      });
  }

}
