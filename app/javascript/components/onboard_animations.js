const cardTransition = () => {
  const forms = document.querySelectorAll('form');
  forms.forEach((form) => {
    form.addEventListener('click', function(){
      const firstCard = document.querySelector('.card-stack .onboard-card:nth-child(2)');
      firstCard.classList.add('fade-out-top');
      setTimeout( () => firstCard.remove(), 500 )
    });
  });
}

// user clicks on option
// trigger fade out top on the first card
// timeout in JS to remove the first card


// get first object
// on click apply "fade out top"
// set timeOut for removal

export { cardTransition }
