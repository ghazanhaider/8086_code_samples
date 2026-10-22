/*
 * main.c
 *
 * Created: 10/8/2026 1:16:22 PM
 *  Author: ghaid
 */ 

#include <xc.h>
#include <avr/sleep.h>

int main(void)
{
	uint32_t boot_delay=0; // For RESET/READY pins
	
	//OSCCAL = 0xA9; // Calibration
	
	// PORTS
	DDRB |= (1 << 1); // direction for PB1 output
	DDRD |= (1 << 6); // direction for PD6 output
	DDRB |= (1 << 7); // direction for PB7 output (RESET PIN INTO 8088)
	PORTB |= (1 << 7); // 8088_RESET=1 before clock timers
	
	// Set the sleep mode to IDLE
	set_sleep_mode(SLEEP_MODE_IDLE);

	// TIMERS	
	// Clear Timer0 Control Registers
	TCCR0A = 0;
	TCCR0B = 0;
	TCNT0  = 0;
	// Clear Timer1 Control Registers
	TCCR1A = 0;
	TCCR1B = 0;
	TCNT1  = 0;
	
	
	
	
	
	// Timer1: 1MHz in Fast PWM mode (WGM mode 14)
	// Output: OC1A on PB1
	// output freq = fclk / (prescale x (1 + top))
	// prescale = 1, top = 7
	
	TCCR1A |= (1 << WGM11);
	TCCR1B |= (1 << WGM12) | (1 << WGM13);
	
	// 2. Set non-inverting mode (Clear OC1A on Compare Match, set at BOTTOM)
	TCCR1A |= (1 << COM1A1);
	
	// 3. Set the TOP value (976 ~1Hz frequency, 8 for the 1mhz clk)
	ICR1 = 2;
	
	OCR1A = 0; // Duty Cycle is % of (ICR1+1) (1 is 50% but 0 is only 25%)
	
	// 5. Set Prescaler to none and start the timer (CS12=1, CS10=1 for 1Hz, CS10=1 for clk)
	TCCR1B |= (1 << CS10);
	
	
	
	
	
	
	// Timer0: 1kHz in Fast PWM mode (WGM mode 7)
	// Output: OC0A on PD6
	// output freq = fclk / (prescale x (1 + top)) = 30.5 Hz
	// prescale = 1, top = 7
	
	TCCR0A |= (1 << WGM00) | (1 << WGM01);
	//TCCR0B |= (1 << WGM02);
	// 2. Set non-inverting mode (Clear OC0A on Compare Match, set at BOTTOM)
	TCCR0A |= (1 << COM0A1);

	
	OCR0A = 70; // TOP
	OCR0B = 200; // Duty cycle, % of OCR0A
	
	// 5. Set Prescaler to 1024 and start the timer
	TCCR0B |= (1 << CS00) | (1 << CS02);
	
    while(1)
    {
		boot_delay++;
		if (boot_delay >= 1000000) { // One second since boot
			PORTB &= ~(1 << 7); // 8088_RESET=0
			
			// Enter sleep mode
			sleep_enable();
			
			while(1) {}
		}
    }
}