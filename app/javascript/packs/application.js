import "bootstrap";

import "../plugins/flatpickr";

import "../plugins/set_timeout"

import "../plugins/fullcalendar";

// import {cardTransition} from "../components/onboard_animation";


import "particles.js"
import "../plugins/particles";

var cardTransition = () => {
  const forms = document.querySelectorAll('form');
  forms.forEach((form) => {
    form.addEventListener('click', function(){
      const firstCard = document.querySelector('.card-stack .onboard-card:nth-child(2)');
      firstCard.classList.add('fade-out-top');
      setTimeout( () => firstCard.remove(), 500 )
    });
  });
}

cardTransition();

import "../components/accordion";
