import { Controller } from 'stimulus'

export default class extends Controller {

  addBookmark(event) {
    event.preventDefault();
    fetch(`/api/v1/bookmarks/${event.target.video_id}/${event.target.user_id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: JSON.stringify(sortable.toArray())
    })
      .then((response) => response.json())
      .then(function(response){
        console.log("hello");
      });
  }

}
