using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace BasicLiquidPhysics2D
{
    /// <summary>
    /// Handles emission of water and pooling.
    /// </summary>
    public class WaterEmitter : MonoBehaviour
    {
        public GameObject waterdrop;

        public int maxWaterObjects = 100;
        public float emitRate = 3;

        public List<Water> waterPool = new List<Water>();

        public bool emit;
        public bool randomizeSize;
        public Vector2 randomSizeRange = new Vector2(0.5f, 0.5f);

        int index;

        float emitTime;


        // Start is called before the first frame update
        void Start()
        {
            for(int i=0;i<maxWaterObjects;i++)
            {
                GameObject g = Instantiate(waterdrop);
                Water w = g.GetComponent<Water>();
                w.Initialize();
                g.transform.SetParent(transform);
                g.SetActive(false);
                waterPool.Add(w);


            }

        }

        // Update is called once per frame
        void Update()
        {
            if(emit)
            {
                emitTime += Time.deltaTime;
                if(emitTime>emitRate)
                {
                    Emit();
                    emitTime = 0;
                }

            }
        }


        public void Emit()
        {
            Water w=waterPool[index];
            w.gameObject.SetActive(true);
            w.transform.position = transform.position+(Random.insideUnitSphere*0.1f);
            index = (index + 1) % waterPool.Count;
            if(randomizeSize)
            {
                w.SetRadius(Random.Range(randomSizeRange.x,randomSizeRange.y));
            }
        }
    }
}