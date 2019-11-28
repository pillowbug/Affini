import Tooltip from 'bootstrap/js/dist/tooltip';

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
  fetch('/checkins.json')
  .then(response => response.json())
  .then((data) => {
    getCalendar(data);
  });
};

const getCalendar = (data) => {
  const calendarEl = document.getElementById('calendar');
  console.log(calendarEl)
  if (calendarEl) {
    const calendar = new Calendar(calendarEl, {
      plugins: [ dayGridPlugin, timeGridPlugin, listPlugin, interactionPlugin ],
      selectable: true,
      events: data,
      header: {
        left:   'title',
        center: '',
        right:  'prev,next'
      },
      eventTextColor: '#ffffff',
      eventColor: '#2C3E50',
      eventRender: function(info) {
        var tooltip = new Tooltip(info.el, {
          title: info.event.extendedProps.description,
          placement: 'top',
          trigger: 'hover',
          container: 'body'
        });
      }
    });

    calendar.render();
  };
};

fetchTime();


