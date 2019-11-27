import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';

import '@fullcalendar/core/main.css';
import '@fullcalendar/daygrid/main.css';
import '@fullcalendar/timegrid/main.css';
import '@fullcalendar/list/main.css';

const fetchTime = () => {
  fetch('./checkins.json')
  .then(response => response.json())
  .then((data) => {
    getCalendar(data);
  });
};

const getCalendar = (data) => {
  const calendarEl = document.getElementById('calendar');
  const calendar = new Calendar(calendarEl, {
    plugins: [ dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin ],
    selectable: true,
    events: data,
    eventClick: function(event, jsEvent, view) {
    console.log('EVENT CLICK ' + event.start);
    },
    eventMouseover: function(event, domEvent) {
    console.log('EVENT Hover ');
  }
  });

  calendar.render();
};

fetchTime();


