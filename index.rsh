'reach 0.1';

const COUNTDOWN = 10;

const Shared = {
  showTime: Fun([UInt], Null),
}
export const main = Reach.App(() => {
  const A = Participant('Alice', {
    ...Shared,
    inheritance: UInt,
    available: Fun([], Bool),
  });
  const B = Participant('Bob', {
    ...Shared,
    acceptTerms: Fun([UInt],Bool),
  });
  init();
  // Alice deploys
  A.only(() => {
    const value = declassify(interact.inheritance);
  })
  A.publish(value)
    .pay(value);
  commit();
  // Bob attaches
  B.only(() => {
    const decision = declassify(interact.acceptTerms(value));
  })
  B.publish(decision);
  commit();

  each([A,B], () => {
    interact.showTime(COUNTDOWN);
  });

  A.only(() => {
    const available = declassify(interact.available());
  })
  A.publish(available);
  // Transfers
  if(!available) {
    transfer(value).to(B);
  } else {
    transfer(value).to(A)
  }
  
  commit();
  exit();
});
