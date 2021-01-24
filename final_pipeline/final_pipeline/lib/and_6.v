module and_6(a,b,c,d,e,f,z);
  input a,b,c,d,e,f;
  output z;
  wire t1, t2, t3, t4;
  and_gate aandg0 (.x(a), .y(b), .z(t1));
  and_gate aandg1 (.x(t1), .y(c), .z(t2));
  and_gate aandg2 (.x(t2), .y(d), .z(t3));
  and_gate aandg3 (.x(t3), .y(e), .z(t4));
  and_gate aandg4 (.x(t4), .y(f), .z(z));
endmodule
