document.addEventListener("turbo:load", function() {
  let dropdown = document.querySelector("#header-dropdown");
  dropdown.addEventListener("mouseover", function(event) {
    event.preventDefault();
    let menu = document.querySelector("#dropdown-menu");
    menu.classList.toggle("active");
  });
  dropdown.addEventListener("mouseout", function(event) {
    event.preventDefault();
    let menu = document.querySelector("#dropdown-menu");
    menu.classList.toggle("active");
  });
});
