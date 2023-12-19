var counterContainer = document.querySelector(".website-counter");
var visitCount = localStorage.getItem("page_view");


// Check if page_view entry is present
if (visitCount) {
    visitCount = Number(visitCount) + 1;
    localStorage.setItem("page_view", visitCount);
  } else {
    visitCount = 1;
    localStorage.setItem("page_view", 1);
 }

// Currently rendering twice, figure out why it doesnt work without it

counterContainer.innerHTML = visitCount;

number = document.querySelector(".website-counter").textContent;
stringNr = [...number].reduce((result, digit) =>  result+=`<span class="digit">${digit}</span>`, "");

counterContainer.innerHTML = stringNr;