#ifndef KV260_GUI_CONTROL_H
#define KV260_GUI_CONTROL_H

/* Call once after lwIP is initialized; poll in the main lwIP context. */
int gui_control_start(void);
void gui_control_poll(void);
/* True while a GUI path transition is draining or settling. */
int gui_control_transition_active(void);

#endif
